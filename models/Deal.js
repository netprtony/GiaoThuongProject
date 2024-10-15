const mongoose = require('mongoose');

const dealSchema = new mongoose.Schema({
  title: String,
  content: String,
  starRatings: [
    {
      userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
      rating: Number
    }
  ],
  comments: [
    {
      userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
      content: String
    }
  ],
}, { timestamps: true });

module.exports = mongoose.model('Deal', dealSchema);
