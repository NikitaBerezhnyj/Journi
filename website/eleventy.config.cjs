const fs = require("node:fs");
const path = require("node:path");

module.exports = function (eleventyConfig) {
  eleventyConfig.ignores.add("src/root-redirect.html");

  eleventyConfig.addPassthroughCopy("src/styles.css");
  eleventyConfig.addPassthroughCopy("src/index.js");
  eleventyConfig.addPassthroughCopy("src/assets");
  eleventyConfig.addPassthroughCopy({ "src/root-redirect.html": "index.html" });

  eleventyConfig.addShortcode("icon", function (name, cls = "icon") {
    const svgPath = path.join(
      __dirname,
      "node_modules/@material-design-icons/svg/filled",
      `${name}.svg`,
    );
    let svg = fs.readFileSync(svgPath, "utf8");

    svg = svg.replace(
      "<svg",
      `<svg class="${cls}" fill="currentColor" aria-hidden="true"`,
    );
    return svg;
  });

  return {
    dir: {
      input: "src",
      output: "_site",
      includes: "_includes",
      data: "_data",
    },
    htmlTemplateEngine: "njk",
  };
};
