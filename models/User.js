const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const userSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: true },
  password: { type: String, required: true, minlength: 6 },
  email: { type: String, required: true, unique: true, match: /.+\@.+\..+/ }, 
  userRoles: { type: [String], default: ['USER'] },
  profile: { type: mongoose.Schema.Types.ObjectId, ref: 'Profile' },
}, { timestamps: true }); 


module.exports = mongoose.model('User', userSchema);
