import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
  build: {
    // Forces Vite to compile assets into 'build/' matching your AWS pipeline expectation
    outDir: 'build' 
  }
})