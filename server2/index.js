// importing modules
const express = require("express");
const http = require("http");
const mongoose = require("mongoose");

const app = express();
const port = process.env.PORT || 3000;
var server = http.createServer(app);
const Room = require("./models/room");
var io = require("socket.io")(server);

// middle ware
app.use(express.json());

const DB = "mongodb+srv://root:mxtec7@cluster0.tltwp13.mongodb.net/?retryWrites=true&w=majority";

io.on("connection", (socket) => {
  console.log("connected!");
  socket.on("createRoom", async ({ nickname }) => {
    console.log(nickname);
    
    var avail = await Room.findOne({isJoin: true}); 
    if(avail) {
      let player = {
        nickname,
        socketID: socket.id,
        playerType: 2,
      };
      socket.join(avail._id);
      avail.players.push(player);
      avail.isJoin = false;
      avail = await avail.save();
      io.to(avail._id).emit("createRoomSuccess", avail);
      io.to(avail._id).emit("updatePlayers", avail.players);
      io.to(avail._id).emit("updateRoom", avail);
      
      
    } else {
      let room = new Room();
      let player = {
        socketID: socket.id,
        nickname,
        playerType: 1,
      };
      room.players.push(player);
      room.turn = player;
      room = await room.save();
      console.log(room);
      const roomId = room._id.toString();

      socket.join(roomId);
      // io -> send data to everyone
      // socket -> sending data to yourself
      io.to(roomId).emit("createRoomSuccess", room);
    }
    
    
    
  });

  socket.on("deleteRoom", async ({ roomId }) => {
    var avail = await Room.findById(roomId);
    if(avail) {
      avail.isJoin = false;
      avail = await avail.save();
      console.log("close room success");
    }
    
  });

  

  socket.on("tap", async ({ index, roomId }) => {
    try {
      let room = await Room.findById(roomId);

      let choice = room.turn.playerType; // 1 or 2
      console.log(choice);
      console.log(index);
      if (room.turnIndex == 0) {
        room.turn = room.players[1];
        room.turnIndex = 1;
      } else {
        room.turn = room.players[0];
        room.turnIndex = 0;
      }
      room = await room.save();
      console.log(room);
      c
    } catch (e) {
      console.log(e);
    }
  });

  socket.on("winner", async ({ winnerSocketId, roomId }) => {
    try {
      let room = await Room.findById(roomId);
      let player = room.players.find(
        (playerr) => playerr.socketID == winnerSocketId
      );
      // player.points += 1;
      // 승자 라운드마다 포인트 주는건데 바꿔야함
      room = await room.save();

      // io.to(roomId).emit("endGame", player);
    } catch (e) {
      console.log(e);
    }
  });

});
  
mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection successful!");
  })
  .catch((e) => {
    console.log(e);
  });

server.listen(port, "0.0.0.0", () => {
  console.log(`Server started and running on port ${port}`);
});
