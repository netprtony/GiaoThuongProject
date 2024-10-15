const User = require('../models/User');
const Profile = require('../models/Profile');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// Đăng nhập
exports.login = async (req, res) => {
    const { username, password } = req.body;
  
    try {
      const user = await User.findOne({ username });
      if (!user) {
        return res.status(401).json({ message: 'Tài khoản không tồn tại' });
      }
  
      const isMatch = await bcrypt.compare(password, user.password);
      if (!isMatch) {
        return res.status(401).json({ message: 'Mật khẩu không đúng' });
      }
  
      const token = jwt.sign({ userId: user._id }, process.env.SECRET_KEY, { expiresIn: '1h' });
  
      res.status(200).json({ message: 'Đăng nhập thành công', token });
    } catch (error) {
      res.status(500).json({ message: 'Đăng nhập thất bại', error });
    }
  };

// Đăng ký
exports.register = async (req, res) => {
  const { username, password, name, gender, dob, phone, company, email, address } = req.body;

  try {
    const existingUser = await User.findOne({ username });
    if (existingUser) {
      return res.status(400).json({ message: 'Tài khoản đã tồn tại' });
    }

    const newUser = new User({
      username,
      password,
      name,
      gender,
      dob,
      phone,
      company,
      email,
      address,
    });
    await newUser.save();

    const newProfile = new Profile({
      userId: newUser._id,
      name,
      gender,
      dob,
      phone,
      company,
      email,
      address,
    });
    await newProfile.save();

    newUser.profile = newProfile._id;
    await newUser.save();

    res.status(200).json({
      message: 'Đăng ký thành công',
      user: { username },
      profile: newProfile,
    });
  } catch (error) {
    res.status(500).json({ message: 'Đăng ký thất bại', error: error.message });
  }
};
