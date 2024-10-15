const express = require('express');
const { rateDeal, commentDeal } = require('../controllers/dealController');
const verifyToken = require('../middleware/authMiddleware');
const router = express.Router();

// Route để thêm đánh giá sao
router.post('/:id/rate', verifyToken, rateDeal);

// Route để thêm bình luận vào deal
router.post('/:id/comment', verifyToken, commentDeal);

module.exports = router;
