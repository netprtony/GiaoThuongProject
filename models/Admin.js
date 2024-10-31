const mongoose = require('mongoose');
const User = require('./User'); 
const bcrypt = require('bcrypt');

async function createAdmin() {
  const username = 'admin'; 
  const password = '123456'; 
  const email = 'admin@gmail.com'; 

  try {
    const existingAdmin = await User.findOne({ username });
    if (existingAdmin) {
      console.log('Admin already exists.');
      return;
    }
    const hashedPassword = await bcrypt.hash(password, 10);
    const admin = new User({
      username,
      password: hashedPassword,
      email,
      userRoles: ['ADMIN'],
    });

    await admin.save();
    console.log('Admin account created successfully.');
  } catch (error) {
    console.error('Error creating admin account:', error);
  }
}
mongoose.connect('mongodb://localhost:27017/ql_giaothuong', { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => {
    console.log('Connected to the database.');
    createAdmin(); 
  })
  .catch(err => {
    console.error('Database connection error:', err);
  });
