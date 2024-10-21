const mongoose = require('mongoose');

// Schema cho bình luận
const commentSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User', // Tham chiếu đến model User
    required: true
  },
  content: {
    type: String,
    required: true
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

// Schema cho deal
const dealSchema = new mongoose.Schema({
  title: String,
  content: String,
  price: Number,
  company: String,
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  comments: [commentSchema], // Lưu danh sách các bình luận
  starRatings: [{
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User'
    },
    rating: Number
  }]
});

// Tạo model Deal
const Deal = mongoose.model('Deal', dealSchema);

module.exports = Deal;
