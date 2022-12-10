const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");
const authRouter = require("./routes/auth");

const PORT = process.env.PORT | 3001;

const app = express();
app.use(cors());
app.use(express.json());

app.use(authRouter);

const DB = "mongodb+srv://ajaypangare:ajay8454@cluster0.qxa92ul.mongodb.net/?retryWrites=true&w=majority";


mongoose.connect(DB)
.then(()=> {
   console.log('mongoose connection successfull!');
   }).catch((err) => {
      console.log(err);
   });

app.listen(PORT, "0.0.0.0", ()=> {
   console.log(`connected at port ${PORT}`);
});