// Servidor local mínimo para previsualizar el reporte mientras se edita.
// Uso: node preview-server.js  →  abrir http://localhost:8145
const http = require('http');
const fs = require('fs');
const path = require('path');

const FILE = path.join(__dirname, 'index.html');
const PORT = process.env.PORT || 8145;

http.createServer((req, res) => {
  fs.readFile(FILE, (err, data) => {
    if (err) {
      res.writeHead(500, { 'Content-Type': 'text/plain; charset=utf-8' });
      res.end('Error leyendo index.html: ' + err.message);
      return;
    }
    res.writeHead(200, {
      'Content-Type': 'text/html; charset=utf-8',
      'Cache-Control': 'no-store, no-cache, must-revalidate',
    });
    res.end(data);
  });
}).listen(PORT, () => {
  console.log('Reporte en http://localhost:' + PORT);
});
