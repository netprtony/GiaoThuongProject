const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const authRoutes = require('./routes/auth');
const dealRoutes = require('./routes/deal');  
const cors = require('cors');
require('dotenv').config();
const app = express();
app.use(cors());
app.use(express.json());
// Kết nối MongoDB
mongoose.connect('mongodb://localhost:27017/ql_giaothuong')
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.error('Could not connect to MongoDB', err));


app.use(bodyParser.json());

app.use('/api/deals', dealRoutes);

app.use('/api/auth', authRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
