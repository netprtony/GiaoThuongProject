const express = require('express');
const router = express.Router();
const dealController = require('../controllers/dealController');
const authMiddleware = require('../middleware/authMiddleware');
router.post('/create', dealController.createDeal);
router.post('/:id/rate', authMiddleware, dealController.rateDeal);
router.post('/:id/comment', authMiddleware, dealController.commentDeal);

module.exports = router;
