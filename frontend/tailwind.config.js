/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./index.html",
    "./src/**/*.elm",
  ],
  theme: {
    extend: {},
  },
  plugins: [require("daisyui")],
  daisyui: {
    themes: [
      {
        mytheme: {
          "accent": "#b1008e",
          "primary": "#d8bef6",
          "secondary": "#300567",
          "neutral": "#d303a9",
          "base-100": "#240549",
          "info": "#3ABFF8",
          "success": "#36D399",
          "warning": "#FBBD23",
          "error": "#dc2626",
        },
      }
    ]
  }
}
