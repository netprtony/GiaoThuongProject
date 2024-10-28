const Deal = require('../models/Deal');


exports.createDeal = async (req, res) => {
  const { title, content, price, company } = req.body;
  const userId = req.userId; // Lấy userId từ middleware

  // Tiến hành tạo deal mới
  try {
    const newDeal = new Deal({
      title,
      content,
      price,
      company,
      createdBy: userId // Lưu thông tin người tạo
    });

    await newDeal.save();
    res.status(201).json({ message: 'Deal đã được tạo thành công', deal: newDeal });
  } catch (error) {
    res.status(500).json({ message: 'Tạo deal thất bại', error: error.message });
  }
};


// Cập nhật deal
exports.updateDeal = async (req, res) => {
  const dealId = req.params.dealId; // Lấy dealId từ tham số URL
  const { title, content, price, company } = req.body;

  try {
    const deal = await Deal.findByIdAndUpdate(dealId, { title, content, price, company }, { new: true });
    if (!deal) {
      return res.status(404).json({ message: 'Deal not found' });
    }
    res.status(200).json(deal);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error updating deal' });
  }
};

// Xóa deal
exports.deleteDeal = async (req, res) => {
  const dealId = req.params.dealId; // Lấy dealId từ tham số URL

  try {
    const deal = await Deal.findByIdAndDelete(dealId);
    if (!deal) {
      return res.status(404).json({ message: 'Deal not found' });
    }
    res.status(200).json({ message: 'Deal deleted successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error deleting deal' });
  }
};

// Lấy danh sách các deal
exports.getDeals = async (req, res) => {
  try {
    const deals = await Deal.find();
    res.status(200).json(deals);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error retrieving deals' });
  }
};

// Thêm bình luận
exports.addComment = async (req, res) => {
  const dealId = req.params.dealId;
  const userId = req.userId; 
  const { content } = req.body; 

  try {
    const deal = await Deal.findById(dealId);
    if (!deal) {
      return res.status(404).json({ message: 'Deal not found' });
    }

    // Thêm bình luận mới vào danh sách comments
    deal.comments.push({ userId, content });
    await deal.save();

    res.status(201).json({ message: 'Comment added successfully', deal });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error adding comment' });
  }
};

// Lấy sự kiện theo ID
exports.getDealById = async (req, res) => {
  try {
    const deal = await Deal.findById(req.params.id);
    if (!deal) return res.status(404).json({ message: 'Deal not found' });
    res.status(200).json(deal);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Thêm đánh giá
exports.addRating = async (req, res) => {
  const dealId = req.params.dealId;
  const userId = req.userId; 
  const { rating } = req.body; 

  try {
    const deal = await Deal.findById(dealId);
    if (!deal) {
      return res.status(404).json({ message: 'Deal not found' });
    }

    // Kiểm tra nếu người dùng đã đánh giá trước đó
    const existingRating = deal.starRatings.find(r => r.userId.toString() === userId);
    if (existingRating) {
      // Nếu đã có đánh giá, cập nhật rating mới
      existingRating.rating = rating;
    } else {
      // Nếu chưa có đánh giá, thêm đánh giá mới
      deal.starRatings.push({ userId, rating });
    }

    await deal.save();
    res.status(200).json({ message: 'Rating added successfully', deal });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Error adding rating' });
  }
};


