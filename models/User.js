const mongoose = require('mongoose');
const bcrypt = require('bcrypt');

const userSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: true },
  password: { type: String, required: true, minlength: 6 },
  email: { type: String, required: true, unique: true, match: /.+\@.+\..+/ }, 
  role: { type: String, default: 'user' },
  profile: { type: mongoose.Schema.Types.ObjectId, ref: 'Profile' },
}, { timestamps: true }); 

/* // Mã hóa mật khẩu trước khi lưu vào cơ sở dữ liệu
userSchema.pre('save', async function(next) {
  if (this.isModified('password')) {
    this.password = await bcrypt.hash(this.password, 10); 
  }
  next();
}); */

module.exports = mongoose.model('User', userSchema);
