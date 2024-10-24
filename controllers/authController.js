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
      console.log('Mật khẩu nhập vào:', password);
      console.log('Mật khẩu lưu trong DB:', user.password);
      
      if (!isMatch) {
        return res.status(401).json({ message: 'Mật khẩu không đúng', enteredPassword: password, storedPassword: user.password });
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
    
    const salt = await bcrypt.genSalt(10); // Tạo salt
    const hashedPassword = await bcrypt.hash(password, salt); // Băm mật khẩu
    console.log('Mật khẩu đã băm:', hashedPassword); // In ra mật khẩu đã băm

    const newUser = new User({
      username,
      password: hashedPassword, // Lưu mật khẩu đã băm
      email,
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


// Lấy thông tin profile
exports.getProfile = async (req, res) => {
  try {
      // Lấy thông tin người dùng dựa vào userId từ token
      const userId = req.userId; // Được thiết lập trong middleware authMiddleware
      const user = await User.findById(userId).populate('profile'); // Lấy thông tin user và profile

      if (!user) {
          return res.status(404).json({ message: 'Người dùng không tồn tại' });
      }

      res.status(200).json({
          message: 'Lấy thông tin thành công',
          user: {
              userId: user._id, 
              username: user.username,
              email: user.email,
              profile: user.profile // Trả về thông tin profile
          },
      });
  } catch (error) {
      res.status(500).json({ message: 'Lấy thông tin thất bại', error });
  }
};


