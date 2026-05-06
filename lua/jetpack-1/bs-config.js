module.exports = {
  server: {
    baseDir: "./build/web",
    middleware: [
      function (req, res, next) {
        // Inject the cross-origin isolation headers required for SharedArrayBuffer
        res.setHeader("Cross-Origin-Opener-Policy", "same-origin");
        res.setHeader("Cross-Origin-Embedder-Policy", "require-corp");
        next();
      }
    ]
  },
  files: ["./build/web/**/*"], // Watch files for changes and auto-reload the page
  port: 8080,
  open: false,                 // Prevents opening a new browser tab every single time you rebuild
  notify: false,               // Disables the annoying "Connected to BrowserSync" pop-up toast in-game
  ui: false                    // Disables BrowserSync's internal admin UI panel to save resources
};