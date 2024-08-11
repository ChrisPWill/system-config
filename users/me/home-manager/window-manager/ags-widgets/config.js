const entry = App.configDir + "/src/main.ts";
const styles = App.configDir + "/src/styles.css";
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
  await Utils.execAsync(["cp", styles, `${outdir}/style.css`]);
  await import(`file://${outdir}/main.js`);
} catch (error) {
  console.error(error);
}

export {};
