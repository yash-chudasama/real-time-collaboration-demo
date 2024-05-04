const express = require("express");
const http = require("http");
const cors = require("cors");

const PORT = process.env.PORT | 3001;

const app = express();
var server = http.createServer(app);
var io = require("socket.io")(server);

app.use(cors());
app.use(express.json());

io.on("connection", (socket) => {
  console.log("Client connected");

  socket.on("typing", (data) => {
    socket.broadcast.emit("changes", data);
  });
});

server.listen(PORT, "0.0.0.0", () => {
  console.log(`connected at port ${PORT}`);
});
