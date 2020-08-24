export default class Map {
  constructor(svg3, ca, tx, ny, zip_num) {
    this.el = svg3;
    this.ca = ca;
    this.tx = tx;
    this.ny = ny;
    this.data = zip_num;
    this.cleanData();
    this.drawMap();
  }

  cleanData() {
    const rowByZip = this.data.reduce((accumulator, d) => {
      accumulator[d.EMPLOYER_POSTAL_CODE] = d;
      return accumulator;
    }, {});

    this.CAzip = topojson.feature(
      this.ca,
      this.ca.objects["California.geo"]
    ).features;

    this.CAzip.forEach((d) => {
      if (rowByZip[d.id]) {
        d.count = +rowByZip[d.id].count;
        if (d.count < 200) {
          d.color = 1;
        } else if (d.count < 400) {
          d.color = 2;
        } else if (d.count < 600) {
          d.color = 3;
        } else if (d.count < 800) {
          d.color = 4;
        } else if (d.count < 1000) {
          d.color = 5;
        } else {
          d.color = 6;
        }
      } else {
        d.count = 0;
        d.color = 0;
      }
    });

    this.TXzip = topojson.feature(
      this.tx,
      this.tx.objects["Texas.geo"]
    ).features;
    this.TXzip.forEach((d) => {
      if (rowByZip[d.id]) {
        d.count = +rowByZip[d.id].count;
        if (d.count < 200) {
          d.color = 1;
        } else if (d.count < 400) {
          d.color = 2;
        } else if (d.count < 600) {
          d.color = 3;
        } else if (d.count < 800) {
          d.color = 4;
        } else if (d.count < 1000) {
          d.color = 5;
        } else {
          d.color = 6;
        }
      } else {
        d.count = 0;
        d.color = 0;
      }
    });

    this.NYzip = topojson.feature(
      this.ny,
      this.ny.objects["New_York.geo"]
    ).features;
    this.NYzip.forEach((d) => {
      if (rowByZip[d.id]) {
        d.count = +rowByZip[d.id].count;
        if (d.count < 200) {
          d.color = 1;
        } else if (d.count < 400) {
          d.color = 2;
        } else if (d.count < 600) {
          d.color = 3;
        } else if (d.count < 800) {
          d.color = 4;
        } else if (d.count < 1000) {
          d.color = 5;
        } else {
          d.color = 6;
        }
      } else {
        d.count = 0;
        d.color = 0;
      }
    });
  }

  drawMap() {
    const colorScale = [
      "#f0f0f0",
      "#a5f0b9",
      "#5ed17d",
      "#3cb55c",
      "#21a644",
      "#02631b",
    ];
    const legendWrap = this.el
      .append("g")
      .attr("class", "legend")
      .attr("transform", "translate(" + 10 + "," + 65 + ")");
    legendWrap
      .append("text")
      .attr("class", "legend title")
      .text("NUMBER OF COMPANIES")
      .attr("x", 0)
      .attr("y", 12);
    const legendRect = legendWrap.append("g").attr("class", "legend rect");
    legendRect
      .selectAll("rect")
      .data(colorScale)
      .enter()
      .append("rect")
      .attr("x", (d, i) => i * 50)
      .attr("y", 20)
      .attr("width", 50)
      .attr("height", 10)
      .attr("fill", (d) => d);
    const legendText = legendWrap.append("g").attr("class", "legend text");
    legendText
      .selectAll("text")
      .data(colorScale)
      .enter()
      .append("text")
      .text((d, i) => {
        if (i < colorScale.length) {
          return i * 200;
        }
      })
      .attr("x", (d, i) => i * 50)
      .attr("y", 50)
      .attr("text-anchor", "middle")
      .attr("fill", "#666666");

    const projection = d3.geoMercator().scale(1500).translate([3260, 1290]);
    const path = d3.geoPath().projection(projection);
    this.el.attr("transform", "translate(0," + 20 + ")");
    this.el
      .append("g")
      .attr("class", "ca map")
      .attr("transform", "translate(0," + 60 + ")")
      .selectAll("path")
      .data(this.CAzip)
      .enter()
      .append("path")
      .attr("class", (d) => `data-color-${d.color}`)
      .attr("fill", (d) => colorScale[d.color])
      .attr("stroke", "#999999")
      .attr("stroke-width", 0.2)
      .attr("d", path);
    const TXprojection = d3.geoMercator().scale(1400).translate([3110, 1230]);
    const TXpath = d3.geoPath().projection(TXprojection);
    this.el
      .append("g")
      .attr("class", "tx map")
      .attr("transform", "translate(" + -200 + "," + -135 + ")")
      .selectAll("path")
      .data(this.TXzip)
      .enter()
      .append("path")
      .attr("class", (d) => `data-color-${d.color}`)
      .attr("fill", (d) => colorScale[d.color])
      .attr("stroke", "#999999")
      .attr("stroke-width", 0.2)
      .attr("d", TXpath);

    const NYprojection = d3.geoMercator().scale(2100).translate([3600, 2000]);
    const NYpath = d3.geoPath().projection(NYprojection);
    this.el
      .append("g")
      .attr("class", "ny map")
      .attr("transform", "translate(" + 0 + "," + 0 + ")")
      .selectAll("path")
      .data(this.NYzip)
      .enter()
      .append("path")
      .attr("class", (d) => `data-color-${d.color}`)
      .attr("stroke", "#999999")
      .attr("stroke-width", 0.2)
      .attr("fill", (d) => colorScale[d.color])
      .attr("d", NYpath);

    this.el
      .append("text")
      .attr("class", "hed")
      .attr("x", 490)
      .attr("y", 20)
      .attr("text-anchor", "middle")
      .text(
        "Enrolled companies cluster in costal California, south of Texas and New York City"
      );
    this.el
      .append("text")
      .attr("class", "subhed")
      .text(
        "Number of companies able to hire foreign employees for permanently positions by zip code"
      )
      .attr("x", 490)
      .attr("y", 20)
      .attr("dy", 25)
      .attr("text-anchor", "middle")
      .attr("fill", "#999999");
    // this.el
    //   .append("text")
    //   .append("tspan")
    //   .attr("class", "subhed")
    //   .attr("x", 0)
    //   .attr("y", 40)
    //   .attr("fill", "#999999")
    //   .text(
    //     "Number of companies in California that are able to hire foreign workers"
    //   )
    //   .append("tspan")
    //   .attr("class", "subhed")
    //   .attr("x", 0)
    //   .attr("y", 40)
    //   .attr("dy", 20)
    //   .attr("fill", "#999999")
    //   .text("permanently by zipcode");

    // .text(
    //   `Number of companies in California that are able to hire foreign workers permanently by zipcode`
    // );
  }
}
