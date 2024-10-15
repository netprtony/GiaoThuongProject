const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: true },
  password: { type: String, required: true, minlength: 6 },
  email: { type: String, required: true, unique: true, match: /.+\@.+\..+/ }, 
  role: { type: String, default: 'user' },
  profile: { type: mongoose.Schema.Types.ObjectId, ref: 'Profile' },
}, { timestamps: true }); 

module.exports = mongoose.model('User', userSchema);
