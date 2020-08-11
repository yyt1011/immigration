const width = 400;
const height = 300;
const margin = { top: 80, right: 100, bottom: 30, left: 80 };
const container1 = d3.select("#chart1");
const container2 = d3.select("#chart2");

const svg1 = container1
  .append("svg")
  .attr("id", "first-chart")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom);

const svg2 = container2
  .append("svg")
  .attr("id", "first-chart")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom);

//import data
// https://github.com/topojson/us-atlas
d3.queue()
  .defer(d3.csv, "emp_loc4.csv") //data downloaded from https://www.foreignlaborcert.doleta.gov/performancedata.cfm
  .await(ready);

function ready(error, emp) {
  if (error) throw error;

  const groupByState = d3
    .nest()
    .key((d) => d.STATE_ABBR)
    .entries(emp);

  //------get ready the data for bar chart-------
  const stateValue = [];
  for (let i = 0; i < groupByState.length; i++) {
    let dict = {};
    dict["key"] = groupByState[i].key;
    dict["value"] = groupByState[i].values.length;
    stateValue.push(dict);
  }
  stateValue.sort((a, b) => b.value - a.value);
  const top10States = stateValue.slice(0, 10);
  console.log(top10States);
  //--------------------bar chart-------------------
  const barContainer = svg1
    .append("g")
    .attr("id", "bar")
    .attr("width", width)
    .attr("height", height)
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  //x, y scales
  //example: https://observablehq.com/@d3/bar-chart
  const y = d3
    .scaleBand()
    .domain(top10States.map((d) => d.key))
    .range([0, height])
    .padding(0.3);

  const x = d3
    .scaleLinear()
    .domain([0, d3.max(stateValue, (d) => d.value)])
    .range([0, width]);

  const yAxis = svg1
    .append("g")
    .attr("class", "y axis")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")")
    .call(d3.axisLeft(y));
  yAxis.select(".domain").remove();
  yAxis.selectAll("line").remove();
  yAxis.selectAll("text").style("font-size", "14px");

  const barDataJoin = barContainer.selectAll("rect").data(top10States).enter();
  barDataJoin
    .append("rect")
    .attr("y", (d) => y(d.key))
    .attr("x", 0)
    .attr("height", y.bandwidth())
    .attr("width", (d) => x(d.value))
    .attr("fill", "steelblue");
  barDataJoin
    .append("text")
    .text((d) => d.value)
    .attr("x", (d) => x(d.value))
    .attr("dx", "0.5em")
    .attr("y", (d) => y(d.key))
    .attr("dy", "1em");
  svg1
    .append("text")
    .text("10 states with the most companies that can hire foreign employees")
    .attr("class", "hed")
    .attr("x", 0)
    .attr("y", 20)
    .attr("dy", 20);
  svg1
    .append("text")
    .text(
      "Number of companies that hold permenant foreign labor certification in each state"
    )
    .attr("class", "subhed")
    .attr("x", 0)
    .attr("y", 20)
    .attr("dy", 40)
    .attr("fill", "#999999");

  //-----------------density chart-------------------
  const densityContainer = svg2
    .append("g")
    .attr("id", "density")
    .attr("width", width)
    .attr("height", height)
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
}
