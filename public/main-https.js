const express = require('express');
const fs = require('fs');
const path = require('path');
const app = express();
const https = require('https');
const { Server } = require("socket.io");
const privateKey = fs.readFileSync('/etc/letsencrypt/live/welljon.xyz/privkey.pem');
const certificate = fs.readFileSync('/etc/letsencrypt/live/welljon.xyz/fullchain.pem');
const credentials = {
  key: privateKey,
  cert: certificate
}
const httpsServer = https.createServer(credentials, app);
const io = new Server();
io.attach(httpsServer);
app.use(express.static(__dirname, 'build'));
app.get('/', (req, res) => {
  res.sendFile('index.html');
});
io.on('connection', (socket) => {
  console.log('a user connected');
});
httpsServer.listen(443, () => {
  console.log('listening on *:443');
});
// Start latency test
io.on("connection", (socket) => {
  socket.on("ping", (cb) => {
    if (typeof cb === "function")
      cb();
  });
});
// End latency test