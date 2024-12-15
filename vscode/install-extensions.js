import { exec } from "child_process";
import { readFile } from "fs/promises";
import { resolve } from "path";

async function getExtAssert() {
  const ret = await readFile(resolve("./ext.json"), "utf-8");
  try {
    return JSON.parse(ret);
  } catch {
    return {};
  }
}

getExtAssert().then((ext) => {
  if (ext.extensions) {
    const cmd = `code --install-extension ${ext.extensions.join(" --install-extension ")}`;
    console.log("cmd is", cmd);
    exec(cmd, (err) => {
      if (err) {
        console.error("install extensions error", err);
        return;
      }

      console.log("install extensions success");
    });
  }
});

