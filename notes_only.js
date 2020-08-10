d3.queue()
  .defer(d3.csv, "emp_loc3.csv") //data downloaded from https://www.foreignlaborcert.doleta.gov/performancedata.cfm
  .defer(d3.json, "us_zipcode.json") //https://gist.github.com/jefffriesen/6892860
  .await(ready);

  //using topojson package to parse the topojson data to geojson data that we need to draw a map
  //topojson.feature converts
  //our RAW geo data into USEABLE geo data
  //always pass it the topojson dataset, then data.objects._something_
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

  //draw zipcode map
  const dataRange = d3.extent(emp, (d) => +d.count);
  const colorScale = d3.scaleLinear().domain(dataRange).range(["blue", "red"]);

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


    //draw state map
    const states = topojson.feature(us, us.objects.states).features;
const counties = topojson.feature(us, us.objects.counties).features;
create a {} with state id be the key and state name be the value
const stateDic = {};
st.forEach((d) => {
  stateDic[d.st] = d.stname;
});

mapWrap.append("g").attr("class", "states-wrap");
const statesWrap = mapWrap
  .selectAll("path")
  .data(states)
  .enter()
  .append("path")
  .attr("class", (d) => `state ${d.id}`)
  .attr("fill", "#f0f0f0")
  .attr("stroke", "black")
  .attr("stroke-width", 0.5)
  .attr("opacity", 0.8)
  .attr("d", path)
  .append("title")
  .text((d) => stateDic[d.id]);
