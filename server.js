const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const authRoutes = require('./routes/auth');
const dealRoutes = require('./routes/deal');  // Import deal route
require('dotenv').config();
const app = express();
// Kết nối MongoDB
mongoose.connect('mongodb://localhost:27017/ql_giaothuong', { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.error('Could not connect to MongoDB', err));

app.use(bodyParser.json());

// Sử dụng route cho deal
app.use('/api/deals', dealRoutes);

// Sử dụng các route khác (như auth) ở đây
app.use('/api/auth', authRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
