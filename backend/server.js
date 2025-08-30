// server.js
require('dotenv').config();
const express = require('express');
const nodemailer = require('nodemailer');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const PORT = process.env.PORT || 3000;
const OTP_TTL_MS = 5 * 60 * 1000; // OTP valid for 5 minutes

// Simple in-memory store: { email -> { otp, expiresAt } }
// For production use a persistent store (Redis / Firestore / DB)
const otpStore = new Map();

// Configure nodemailer with Gmail (use App Password)
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.SMTP_EMAIL,
    pass: process.env.SMTP_PASS, // app password
  },
});

// Health check
app.get('/', (req, res) => res.json({ status: 'ok' }));

// POST /send-otp  { email }
app.post('/send-otp', async (req, res) => {
  try {
    const { email } = req.body || {};
    if (!email) {
      return res.status(400).json({ status: 'error', message: 'Email is required' });
    }

    const otp = (100000 + Math.floor(Math.random() * 900000)).toString();
    const expiresAt = Date.now() + OTP_TTL_MS;

    otpStore.set(email, { otp, expiresAt });

    const mailOptions = {
      from: process.env.SMTP_EMAIL,
      to: email,
      subject: 'Your OTP for CrediSense',
      text: `Your OTP is ${otp}. It will expire in 5 minutes.`,
      html: `<p>Your OTP is <b>${otp}</b>. It will expire in 5 minutes.</p>`,
    };

    await transporter.sendMail(mailOptions);
    console.log(`OTP ${otp} sent to ${email}`);
    return res.json({ status: 'success', message: 'OTP sent' });
  } catch (err) {
    console.error('send-otp error:', err);
    return res.status(500).json({ status: 'error', message: 'Failed to send OTP', error: err.toString() });
  }
});

// POST /verify-otp { email, otp }
app.post('/verify-otp', (req, res) => {
  try {
    const { email, otp } = req.body || {};
    if (!email || !otp) {
      return res.status(400).json({ status: 'error', message: 'Email and OTP are required' });
    }

    const entry = otpStore.get(email);
    if (!entry) return res.status(404).json({ status: 'not_found', message: 'No OTP found' });

    if (Date.now() > entry.expiresAt) {
      otpStore.delete(email);
      return res.status(400).json({ status: 'expired', message: 'OTP expired' });
    }

    if (entry.otp !== otp) {
      return res.status(400).json({ status: 'invalid', message: 'OTP invalid' });
    }

    // success -> remove OTP (one-time use)
    otpStore.delete(email);
    return res.json({ status: 'success', message: 'OTP verified' });
  } catch (err) {
    console.error('verify-otp error:', err);
    return res.status(500).json({ status: 'error', message: 'Server error' });
  }
});

// Cleanup expired OTPs every minute
setInterval(() => {
  const now = Date.now();
  for (const [email, { expiresAt }] of otpStore.entries()) {
    if (expiresAt <= now) otpStore.delete(email);
  }
}, 60 * 1000);

app.listen(PORT, () => {
  console.log(`OTP server listening on port ${PORT}`);
});
