const User = require('../models/User');
const Profile = require('../models/Profile');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// Đăng ký
exports.register = async (req, res) => {
  const { username, password, name, gender, dob, phone, company, email, address } = req.body;

  try {
    const existingUser = await User.findOne({ username });
    if (existingUser) {
      return res.status(400).json({ message: 'Tài khoản đã tồn tại' });
    }

    const existingEmail = await User.findOne({ email });
    if (existingEmail) {
      return res.status(400).json({ message: 'Email đã tồn tại' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    console.log('Mật khẩu đã băm:', hashedPassword);

    const newUser = new User({
      username,
      password: hashedPassword,
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
    console.log('Kết quả so sánh:', isMatch);
    
    if (!isMatch) {
      return res.status(401).json({ message: 'Mật khẩu không đúng' });
    }

    const token = jwt.sign({ userId: user._id }, process.env.SECRET_KEY, { expiresIn: '1h' });

    res.status(200).json({ message: 'Đăng nhập thành công', token });
  } catch (error) {
    res.status(500).json({ message: 'Đăng nhập thất bại', error: error.message });
  }
};

// Lấy danh sách người dùng
exports.listUsers = async (req, res) => {
  try {
    const users = await User.find();
    res.json({ code: 1000, result: users });
  } catch (err) {
    res.status(500).json({ code: 1001, message: 'Lỗi khi lấy danh sách người dùng' });
  }
};

// Cập nhật vai trò của người dùng
exports.updateUserRole = async (req, res) => {
  const { username } = req.params;
  const { roles } = req.body;

  try {
    const user = await User.findOneAndUpdate(
      { username },
      { userRoles: roles },
      { new: true }
    );

    if (!user) {
      return res.status(404).json({ code: 1002, message: 'Không tìm thấy người dùng' });
    }

    res.json({ code: 1000, result: user });
  } catch (err) {
    res.status(500).json({ code: 1003, message: 'Lỗi khi cập nhật vai trò người dùng' });
  }
};

// Lấy thông tin profile
exports.getProfile = async (req, res) => {
  try {
    const userId = req.userId; // Lấy userId từ middleware xác thực
    const user = await User.findById(userId).populate('profile');

    if (!user) {
      return res.status(404).json({ message: 'Người dùng không tồn tại' });
    }

    res.status(200).json({
      message: 'Lấy thông tin thành công',
      user: {
        userId: user._id,
        username: user.username,
        email: user.email,
        profile: user.profile,
      },
    });
  } catch (error) {
    res.status(500).json({ message: 'Lấy thông tin thất bại', error: error.message });
  }
};
