import React, { useState, useEffect } from 'react';

function App() {
  const [systemStatus, setSystemStatus] = useState('Connecting to API Gateway...');
  const [transactions, setTransactions] = useState([]);
  const [error, setError] = useState(null);

  // In production, this URL is injected via environment variables pointing to your ALB DNS
  const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://your-alb-dns-name.amazonaws.com';

  useEffect(() => {
    // Fetch system health metrics through the public ALB
    fetch(`${API_BASE_URL}/health`)
      .then((res) => {
        if (!res.ok) throw new Error('API Gateway returned an error status');
        return res.json();
      })
      .then((data) => setSystemStatus(`System Online. Core DB: ${data.database}`))
      .catch((err) => {
        setError(err.message);
        setSystemStatus('System Degradation Detected');
      });
  }, [API_BASE_URL]);

  return (
    <div style={{ padding: '40px', fontFamily: 'sans-serif', backgroundColor: '#f4f6f9', minHeight: '100vh' }}>
      <header style={{ borderBottom: '2px solid #eaeaea', paddingBottom: '20px' }}>
        <h1 style={{ color: '#1e293b', margin: 0 }}>Fintech Platform Control Console</h1>
        <p style={{ 
          display: 'inline-block', 
          padding: '6px 12px', 
          borderRadius: '4px', 
          fontSize: '14px',
          fontWeight: 'bold',
          backgroundColor: error ? '#fee2e2' : '#dcfce7', 
          color: error ? '#991b1b' : '#166534',
          marginTop: '10px'
        }}>
          Status: {systemStatus}
        </p>
      </header>

      <main style={{ marginTop: '30px' }}>
        <div style={{ backgroundColor: '#ffffff', padding: '24px', borderRadius: '8px', boxShadow: '0 1px 3px rgba(0,0,0,0.1)' }}>
          <h2 style={{ color: '#334155', marginTop: 0 }}>Ledger Transactions Ledger</h2>
          {error && <p style={{ color: '#dc2626' }}>Error syncing ledger: {error}</p>}
          {transactions.length === 0 ? (
            <p style={{ color: '#64748b' }}>No recent transaction data inside ledger.</p>
          ) : (
            <ul>
              {transactions.map((tx, idx) => (
                <li key={idx}>{tx.amount} - {tx.status}</li>
              ))}
            </ul>
          )}
        </div>
      </main>
    </div>
  );
}

export default App;