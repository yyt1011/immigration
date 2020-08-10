const width = 400;
const height = 300;
const margin = { top: 20, right: 40, bottom: 30, left: 30 };
const container = d3.select("#chart");

const svg = container
  .append("svg")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom);

//set the projection for the path generator
const projection = d3.geoAlbersUsa().scale(1100).translate([487.5, 305]);
const path = d3.geoPath().projection(projection);

//import data
// https://github.com/topojson/us-atlas
d3.queue()
  .defer(d3.csv, "emp_loc3.csv") //data downloaded from https://www.foreignlaborcert.doleta.gov/performancedata.cfm
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
  const barContainer = svg
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

  const yAxis = svg
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
    .attr("x", (d) => x(d.value) + 8)
    .attr("y", (d) => y(d.key))
    .attr("dy", "1em");
}
