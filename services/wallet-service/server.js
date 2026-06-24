const express = require('express');
const { Pool } = require('pg');

const app = express();
const PORT = 8080;

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
  port: 5432
});

// ALB Health check must remain open for target mapping to clear status
app.get('/wallet/health', (req, res) => {
  res.status(200).json({ status: 'healthy', service: 'wallet-service' });
});

// PROTECTED ROUTES
app.get('/api/wallet', securityAuthenticator, async (req, res) => {
  try {
    res.json({ success: true, service: 'wallet-ledger', balance: 5000.00, currency: 'GBP' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.listen(PORT, () => console.log(`Wallet microservice live on port ${PORT}`));