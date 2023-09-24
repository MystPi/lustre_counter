import gleam from 'vite-gleam';
import { defineConfig } from 'vite';

export default defineConfig({
  plugins: [gleam()],
  base: '/lustre_counter/',
});
