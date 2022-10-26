import { defineConfig } from "vite";
import elmPlugin from "vite-plugin-elm";
import Unocss from 'unocss/vite';

export default defineConfig({
  plugins: [elmPlugin(), Unocss({}),],
});
