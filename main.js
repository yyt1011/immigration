const width = 800;
const height = 600;
const margin = { top: 40, right: 40, bottom: 60, left: 60 };
const container = d3.select("#chart");

const svg = container
  .append("svg")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom)
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

//set the projection for the path generator
const projection = d3.geoAlbersUsa().scale(1100).translate([487.5, 305]);
const path = d3.geoPath().projection(projection);

//import data
// https://github.com/topojson/us-atlas
d3.queue()
  .defer(d3.csv, "emp_loc2.csv") //data downloaded from https://www.foreignlaborcert.doleta.gov/performancedata.cfm
  // .defer(d3.json, "us.json") //data downloaded from github for drawing US map
  .defer(d3.json, "us_zipcode.json") //https://gist.github.com/jefffriesen/6892860
  // .defer(d3.csv, "FIPS.csv") //data for matching state names with their IDs (used in topo json)
  .await(ready);

function ready(error, emp, zipcode) {
  if (error) throw error;

  //using topojson package to parse the topojson data to geojson data that we need to draw a map
  //topojson.feature converts
  //our RAW geo data into USEABLE geo data
  //always pass it data, then data.objects._something_
  //then get .features out of it
  const zipcodes = topojson.feature(
    zipcode,
    zipcode.objects.zip_codes_for_the_usa
  ).features;
  const mapWrap = svg.append("g").attr("class", "us map");
  //wrap states and counties in separate wraps, so both layers will be draw at the same place

  //------draw map------
  //match zipcode and value
  const rowByZip = emp.reduce((accumulator, d) => {
    accumulator[d.EMPLOYER_POSTAL_CODE] = d;
    return accumulator;
  }, {});
  zipcodes.forEach((d) => {
    if (rowByZip[d.properties.zip]) {
      d.properties.count = +rowByZip[d.properties.zip].count;
    } else {
      d.properties.count = 0;
    }
  });
  const dataRange = d3.extent(emp, (d) => +d.count);
  const colorScale = d3.scaleLinear().domain(dataRange).range(["blue", "red"]);

  // const d = [zipcodes[27081].properties.count];
  // console.log(zipcodes);
  // svg
  //   .append("g")
  //   .attr("class", "color")
  //   .selectAll("circle")
  //   .data(d)
  //   .enter()
  //   .append("circle")
  //   .attr("cx", 100)
  //   .attr("cy", 100)
  //   .attr("r", 10)
  //   .attr("fill", (d) => colorScale(d))
  //   .attr("stroke", "black");

  const zipcodeWrap = mapWrap.append("g").attr("class", "zipcodeWrap");
  zipcodeWrap
    .selectAll("path")
    .data(zipcodes)
    .enter()
    .append("path")
    .attr("class", "zipcode")
    .attr("fill", (d) => {
      return `${colorScale(d.properties.count)}`;
    })
    .attr("stroke", "white")
    .attr("stroke-width", 0.5)
    .attr("d", path);
}

// const states = topojson.feature(us, us.objects.states).features;
// const counties = topojson.feature(us, us.objects.counties).features;
//create a {} with state id be the key and state name be the value
// const stateDic = {};
// st.forEach((d) => {
//   stateDic[d.st] = d.stname;
// });

// mapWrap.append("g").attr("class", "states-wrap");
// const statesWrap = mapWrap
//   .selectAll("path")
//   .data(states)
//   .enter()
//   .append("path")
//   .attr("class", (d) => `state ${d.id}`)
//   .attr("fill", "#f0f0f0")
//   .attr("stroke", "black")
//   .attr("stroke-width", 0.5)
//   .attr("opacity", 0.8)
//   .attr("d", path)
//   .append("title")
//   .text((d) => stateDic[d.id]);
