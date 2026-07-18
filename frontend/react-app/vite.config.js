import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  base: './', // Enforces relative asset paths to prevent S3 routing glitches
  build: {
    outDir: 'build'
  },
  define: {
    // Injects a browser shield so legacy process.env tokens do not crash the application
    'process.env': {
      REACT_APP_API_URL: process.env.REACT_APP_API_URL
    }
  }
})