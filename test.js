var faithfulData = [
  88,
  88,
  88,
  88,
  88,
  88,
  88,
  85,
  51,
  85,
  54,
  84,
  78,
  47,
  83,
  52,
  62,
  84,
  52,
  79,
  51,
  47,
  78,
  69,
  74,
  83,
  55,
  76,
  78,
  79,
  73,
  77,
  66,
  80,
  74,
  52,
  48,
  80,
  59,
  90,
  80,
  58,
  84,
  58,
  73,
  83,
  64,
  53,
  82,
  59,
  75,
  90,
  54,
  80,
  54,
  83,
  71,
  64,
  77,
  81,
  59,
  84,
  48,
  82,
  60,
  92,
  78,
  78,
  65,
  73,
  82,
  56,
  79,
  71,
  62,
  76,
  60,
  78,
  76,
  83,
  75,
  82,
  70,
  65,
  73,
  88,
  76,
  80,
  48,
  86,
  60,
  90,
  50,
  78,
  63,
  72,
  84,
  75,
  51,
  82,
  62,
  88,
  49,
  83,
  81,
  47,
  84,
  52,
  86,
  81,
  75,
  59,
  89,
  79,
  59,
  81,
  50,
  85,
  59,
  87,
  53,
  69,
  77,
  56,
  88,
  81,
  45,
  82,
  55,
  90,
  45,
  83,
  56,
  89,
  46,
  82,
  51,
  86,
  53,
  79,
  81,
  60,
  82,
  77,
  76,
  59,
  80,
  49,
  96,
  53,
  77,
  77,
  65,
  81,
  71,
  70,
  81,
  93,
  53,
  89,
  45,
  86,
  58,
  78,
  66,
  76,
  63,
  88,
  52,
  93,
  49,
  57,
  77,
  68,
  81,
  81,
  73,
  50,
  85,
  74,
  55,
  77,
  83,
  83,
  51,
  78,
  84,
  46,
  83,
  55,
  81,
  57,
  76,
  84,
  77,
  81,
  87,
  77,
  51,
  78,
  60,
  82,
  91,
  53,
  78,
  46,
  77,
  84,
  49,
  83,
  71,
  80,
  49,
  75,
  64,
  76,
  53,
  94,
  55,
  76,
  50,
  82,
  54,
  75,
  78,
  79,
  78,
  78,
  70,
  79,
  70,
  54,
  86,
  50,
  90,
  54,
  54,
  77,
  79,
  64,
  75,
  47,
  86,
  63,
  85,
  82,
  57,
  82,
  67,
  74,
  54,
  83,
  73,
  73,
  88,
  80,
  71,
  83,
  56,
  79,
  78,
  84,
  58,
  83,
  43,
  60,
  75,
  81,
  46,
  90,
  46,
  74,
];

const width = 400;
const height = 300;
const margin = { top: 80, right: 100, bottom: 30, left: 80 };
const container2 = d3.select("#chart2");

const svg2 = container2
  .append("svg")
  .attr("id", "second-chart")
  .attr("width", width + margin.left + margin.right)
  .attr("height", height + margin.top + margin.bottom);

const densityContainer = svg2
  .append("g")
  .attr("id", "density")
  .attr("width", width)
  .attr("height", height)
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

var line = d3
  .line()
  .x(function (d) {
    return x(d[0]);
  })
  .y(function (d) {
    return y(d[1]);
  });

const x = d3.scaleLinear().domain([0, 100]).range([0, width]);

const xAxis = densityContainer
  .append("g")
  .attr("class", "x axis density")
  .attr("transform", "translate(0," + height + ")")
  .call(d3.axisBottom(x));

const y = d3.scaleLinear().domain([0, 0.001]).range([height, 0]);
const yAxis2Appr = densityContainer
  .append("g")
  .attr("class", "y axis appr")
  .call(d3.axisLeft(y));

// var data = histogram(faithfulData),
var kde = kernelDensityEstimator(epanechnikovKernel(7), x.ticks(100));

// svg2
//   .selectAll(".bar")
//   .data(data)
//   .enter()
//   .insert("rect", ".axis")
//   .attr("class", "bar")
//   .attr("x", function (d) {
//     return x(d.x) + 1;
//   })
//   .attr("y", function (d) {
//     return y(d.y);
//   })
//   .attr("width", x(data[0].dx + data[0].x) - x(data[0].x) - 1)
//   .attr("height", function (d) {
//     return height - y(d.y);
//   });

svg2
  .append("path")
  .datum(kde(faithfulData))
  .attr("class", "line")
  .attr("d", line);
//});

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
