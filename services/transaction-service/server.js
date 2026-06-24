const express = require('express');
const { Pool } = require('pg');

const app = express();
const PORT = process.env.PORT || 8080;

app.use(express.json());

// --- AUTHENTICATION MIDDLEWARE SECURITY SHIELD ---
const securityAuthenticator = (req, res, next) => {
  const platformToken = req.headers['x-platform-token'];
  if (!platformToken || platformToken !== 'FintechSandboxSecureToken2026') {
    return res.status(401).json({ 
      success: false, 
      error: 'Access Denied: Request lacks valid authentication credentials.' 
    });
  }
  next();
};

const pool = new Pool({
  host: process.env.DB_HOST,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  port: 5432,
  connectionTimeoutMillis: 5000 
});

// ALB Health check must remain open for target mapping to clear status
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy', service: 'transaction-service' });
});

// PROTECTED ROUTES
app.get('/api/transactions', securityAuthenticator, async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM transactions ORDER BY created_at DESC LIMIT 10');
    res.json({ success: true, service: 'transaction', data: result.rows });
  } catch (err) {
    res.status(500).json({ success: false, error: err.message });
  }
});

app.listen(PORT, () => {
  console.log(`Transaction engine listening safely on port ${PORT}`);
});