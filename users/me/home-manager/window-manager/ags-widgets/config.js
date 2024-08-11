const entry = App.configDir + "/src/main.ts";
const styles = App.configDir + "/src/styles.scss";
const outdir = "/tmp/ags/js";

try {
  await Utils.execAsync([
    "bun",
    "build",
    entry,
    "--outdir",
    outdir,
    "--external",
    "resource://*",
    "--external",
    "gi://*",
  ]);
  await Utils.execAsync(["sass", styles, `${outdir}/style.css`]);
  await import(`file://${outdir}/main.js`);
} catch (error) {
  console.error(error);
}

export {};
