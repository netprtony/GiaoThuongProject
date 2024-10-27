const jwt = require('jsonwebtoken');

const authMiddleware = (req, res, next) => {
    const token = req.headers['authorization']; // Lấy token từ header
    if (!token) return res.status(401).json({ message: 'Token không được cung cấp' }); // Kiểm tra token

    try {
        const decoded = jwt.verify(token, process.env.SECRET_KEY); // Xác thực token
        req.userId = decoded.userId; // Lưu userId vào request để sử dụng ở các route tiếp theo
        next(); 
    } catch (error) {
        return res.status(401).json({ message: 'Xác thực không hợp lệ', error }); // Trả về lỗi nếu token không hợp lệ
    }
};

module.exports = authMiddleware;
