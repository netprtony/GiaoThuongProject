const express = require('express');
const router = express.Router();
const dealController = require('../controllers/dealController');
const authMiddleware = require('../middleware/authMiddleware'); 


router.post('/create', authMiddleware, dealController.createDeal); 
router.put('/update/:dealId', authMiddleware, dealController.updateDeal); 
router.delete('/delete/:dealId', authMiddleware, dealController.deleteDeal); 
router.get('/list', dealController.getDeals); 
router.post('/comment/:dealId', authMiddleware, dealController.addComment); 
router.post('/rating/:dealId', authMiddleware, dealController.addRating); 

module.exports = router;
