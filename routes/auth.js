const express = require('express');
const authController = require('../controllers/authController');
const authMiddleware = require('../middleware/authMiddleware');
const router = express.Router();

// Route đăng nhập và đăng ký không cần xác thực
router.post('/login', authController.login);
router.post('/register', authController.register);

// Route cần xác thực
router.get('/profile', authMiddleware, authController.getProfile);

module.exports = router;
