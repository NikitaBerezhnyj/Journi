const fs = require("node:fs");
const path = require("node:path");

module.exports = function () {
  const dir = path.join(__dirname, "../i18n");
  const files = fs.readdirSync(dir).filter((f) => f.endsWith(".json"));
  return files
    .map((file) => JSON.parse(fs.readFileSync(path.join(dir, file), "utf8")))
    .sort((a, b) => a.code.localeCompare(b.code));
};
