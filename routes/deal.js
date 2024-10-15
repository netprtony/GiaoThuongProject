const express = require('express');
const router = express.Router();
const dealController = require('../controllers/dealController');

// Đảm bảo rằng bạn đang sử dụng đúng các hàm từ dealController
router.post('/:id/rate', dealController.rateDeal);
router.post('/:id/comment', dealController.commentDeal);

module.exports = router;
