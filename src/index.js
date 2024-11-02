const express = require("express");

const app = express();

app.get("/api/healthcheck", async (_req, res) => {
  return res.status(200).json({
    status: "OK",
  });
});

app.get("/", async (_req, res) => {
  return res.status(200).json({
    message: "Hello World",
  });
});

app.listen(8000, () => {
  console.info("server running on port 8000");
});
