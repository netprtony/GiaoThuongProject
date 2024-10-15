const Deal = require('../models/Deal');

// Thêm đánh giá sao cho deal
exports.rateDeal = async (req, res) => {
  const dealId = req.params.id;
  const { rating } = req.body;

  // Kiểm tra xem rating có hợp lệ không
  if (!rating || rating < 1 || rating > 5) {
    return res.status(400).json({ message: 'Đánh giá phải nằm trong khoảng từ 1 đến 5 sao' });
  }

  try {
    const deal = await Deal.findById(dealId);
    if (!deal) {
      return res.status(404).json({ message: 'Không tìm thấy deal' });
    }

    // Kiểm tra xem người dùng đã đánh giá trước đó chưa
    const existingRating = deal.starRatings.find(r => r.userId.equals(req.user.userId));
    if (existingRating) {
      // Cập nhật đánh giá nếu đã tồn tại
      existingRating.rating = rating;
    } else {
      // Thêm đánh giá mới
      deal.starRatings.push({ userId: req.user.userId, rating });
    }

    await deal.save();
    res.status(200).json({ message: 'Đánh giá thành công', starRatings: deal.starRatings });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi đánh giá deal', error });
  }
};

// Thêm bình luận cho deal
exports.commentDeal = async (req, res) => {
  const dealId = req.params.id;
  const { content } = req.body;

  if (!content || content.trim() === '') {
    return res.status(400).json({ message: 'Nội dung bình luận không được để trống' });
  }

  try {
    const deal = await Deal.findById(dealId);
    if (!deal) {
      return res.status(404).json({ message: 'Không tìm thấy sự kiện' });
    }

    // Thêm bình luận vào sự kiện
    deal.comments.push({ userId: req.user.userId, content });
    await deal.save();

    res.status(200).json({ message: 'Bình luận thành công', comments: deal.comments });
  } catch (error) {
    res.status(500).json({ message: 'Lỗi khi bình luận vào sự kiện', error });
  }
};
