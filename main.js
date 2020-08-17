const width = 400;
const height = 300;
const margin = { top: 80, right: 100, bottom: 50, left: 80 };
const container1 = d3.select("#chart1");
const container2 = d3.select("#chart2");

const svg1 = container1
  .append("svg")
  .attr("id", "first-chart")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom);

const svg2 = container2
  .append("svg")
  .attr("id", "second-chart")
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
    .attr("fill", "#56dbac");
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
  //filter data to include only certified and denied cases

  const Appr = emp.filter((d) => d.CASE_STATUS == "Certified");
  const Deny = emp.filter((d) => d.CASE_STATUS == "Denied");
  Appr.forEach((d) => {
    return (d.PROCESS_YEAR = Math.round((d.PROCESS_TIME / 365) * 10) / 10);
  });
  //this is for the text of the story, not for chart
  const cases = emp.filter((d) => d.CASE_STATUS == "Certified");
  const moreThanAYear = cases.filter((d) => d.PROCESS_TIME > 365);
  const lessThanAYear = cases.filter((d) => d.PROCESS_TIME < 365);

  //x,y axis
  const x2 = d3
    .scaleLinear()
    //.domain(d3.extent(Appr, (d) => +d.PROCESS_YEAR)) //02. 9.6
    .domain([0, 3500])
    .range([0, width]);

  const xAxis2 = densityContainer
    .append("g")
    .attr("class", "x axis density")
    .attr("transform", "translate(0," + height + ")")
    .call(d3.axisBottom(x2));
  densityContainer
    .append("text")
    .attr("class", "x axis label")
    .attr("x", width / 2)
    .attr("y", height)
    .attr("dy", "40px")
    .text("Days")
    .style("text-anchor", "middle");

  const y2Appr = d3
    .scaleLinear()
    .domain([0, 0.014])
    .range([height / 2, 0]);
  densityContainer
    .append("g")
    .attr("class", "y2")
    .call(d3.axisLeft(y2Appr).ticks(4));
  const y2Deny = d3
    .scaleLinear()
    .domain([0, 0.014])
    .range([height / 2, height]);
  densityContainer
    .append("g")
    .attr("class", "y2")
    .call(d3.axisLeft(y2Deny).ticks(4));
  const y2 = d3.selectAll(".y2");
  y2.selectAll(".tick").selectAll("line").remove();

  //Compute kernel density estimation
  const kde = kernelDensityEstimator(epanechnikovKernel(7), x2.ticks(60));
  const densityAppr = kde(Appr.map((d) => d.PROCESS_TIME));
  const densityDeny = kde(Deny.map((d) => d.PROCESS_TIME));
  densityContainer
    .append("path")
    .attr("class", "appr")
    .datum(densityAppr)
    .attr("fill", "#56dbac")
    .attr("fill-opacity", 0.8)
    .attr("stroke", "black")
    .attr("stroke-width", 1)
    .attr(
      "d",
      d3
        .line()
        .x((d) => x2(d[0]))
        .y((d) => y2Appr(d[1]))
    );
  densityContainer
    .append("path")
    .attr("class", "appr")
    .datum(densityDeny)
    .attr("fill", "#e35bc8")
    .attr("fill-opacity", 0.8)
    .attr("stroke", "black")
    .attr("stroke-width", 1)
    .attr(
      "d",
      d3
        .line()
        .x((d) => x2(d[0]))
        .y((d) => y2Deny(d[1]))
    );

  // Function to compute density
  function kernelDensityEstimator(kernel, x) {
    return function (sample) {
      return x.map(function (x) {
        return [
          x,
          d3.mean(sample, function (v) {
            return kernel(x - v);
          }),
        ];
      });
    };
  }

  function epanechnikovKernel(scale) {
    return function (u) {
      return Math.abs((u /= scale)) <= 1 ? (0.75 * (1 - u * u)) / scale : 0;
    };
  }

  // legend
  densityContainer
    .append("circle")
    .attr("class", "legend appr")
    .attr("r", 5)
    .attr("cx", 250)
    .attr("cy", 20)
    .attr("fill", "#56dbac")
    .attr("stroke", "black");
  densityContainer
    .append("circle")
    .attr("class", "legend deny")
    .attr("r", 5)
    .attr("cx", 250)
    .attr("cy", 40)
    .attr("fill", "#e35bc8")
    .attr("stroke", "black");
  densityContainer
    .append("text")
    .attr("class", "legend appr")
    .attr("x", 270)
    .attr("y", 25)
    .text("Certified cases");
  densityContainer
    .append("text")
    .attr("class", "legend deny")
    .attr("x", 270)
    .attr("y", 45)
    .text("Denied cases");
  svg2
    .append("text")
    .text("Most cases were decided within a year")
    .attr("class", "hed")
    .attr("x", 0)
    .attr("y", 20)
    .attr("dy", 20);
  svg2
    .append("text")
    .text(
      "Distribution of case process time (a case's received date and decision date)"
    )
    .attr("class", "subhed")
    .attr("x", 0)
    .attr("y", 20)
    .attr("dy", 40)
    .attr("fill", "#999999");
}
