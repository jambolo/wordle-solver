import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import coffee from 'vite-plugin-coffee'

export default defineConfig({
  plugins: [
    coffee({ jsx: true }),
    react(),
  ],
  base: './',
  build: {
    outDir: 'build',
    sourcemap: false,
    minify: 'esbuild',
    target: 'esnext',
    chunkSizeWarningLimit: 500,
    rolldownOptions: {
      output: {
        codeSplitting: {
          groups: [
            { name: 'database', test: /cs\/database\.json/ },
            { name: 'vendor', test: /node_modules/ },
          ],
        },
      },
    },
  },
  server: {
    port: 3000,
    open: true,
  },
  preview: {
    port: 3000,
  },
  resolve: {
    extensions: ['.coffee', '.js', '.jsx', '.json'],
  },
})
