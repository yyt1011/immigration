export default class Map {
  constructor(svg3, zip, zip_num) {
    this.el = svg3;
    this.json = zip;
    this.data = zip_num;
    this.cleanData();
    this.drawMap();
  }

  cleanData() {
    const rowByZip = this.data.reduce((accumulator, d) => {
      accumulator[d.EMPLOYER_POSTAL_CODE] = d;
      return accumulator;
    }, {});

    this.zip = topojson.feature(
      this.json,
      this.json.objects["California.geo"]
    ).features;

    this.zip.forEach((d) => {
      if (rowByZip[d.id]) {
        d.count = +rowByZip[d.id].count;
      } else {
        d.count = 0;
      }
    });
  }

  drawMap() {
    const projection = d3.geoMercator().scale(1500).translate([3450, 1240]);
    const path = d3.geoPath().projection(projection);
    const colorScale = d3
      .scaleLinear()
      .domain([0, 10])
      .range(["#ffffff", "#56dbac"]);
    this.el.attr("transform", "translate(0," + 20 + ")");
    const g = this.el
      .append("g")
      .attr("class", "map")
      .attr("transform", "translate(0," + 60 + ")")
      .selectAll("path")
      .data(this.zip)
      .enter()
      .append("path")
      .attr("fill", (d) => colorScale(d.count))
      .attr("stroke", "#666666")
      .attr("stroke-width", 0.5)
      .attr("d", path);
    this.el
      .append("text")
      .attr("x", 0)
      .attr("y", 20)
      .attr("class", "hed")
      .text("Costal areas in California offer more position for foreigners");
    this.el
      .append("text")
      .append("tspan")
      .attr("class", "subhed")
      .attr("x", 0)
      .attr("y", 40)
      .attr("fill", "#999999")
      .text(
        "Number of companies in California that are able to hire foreign workers"
      )
      .append("tspan")
      .attr("class", "subhed")
      .attr("x", 0)
      .attr("y", 40)
      .attr("dy", 20)
      .attr("fill", "#999999")
      .text("permanently by zipcode");

    // .text(
    //   `Number of companies in California that are able to hire foreign workers permanently by zipcode`
    // );
  }
}
