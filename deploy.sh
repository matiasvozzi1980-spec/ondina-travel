#!/bin/bash
# Deploy Ondina Travel a GitHub Pages
# Uso: ./deploy.sh ["mensaje de commit opcional"]

set -e
cd "$(dirname "$0")"

echo "🔄 Sincronizando index.html con ondina-travel.html..."
cp ondina-travel.html index.html

echo "🔍 Validando sintaxis JS..."
node -e "
const fs = require('fs');
const html = fs.readFileSync('ondina-travel.html', 'utf8');
const match = html.match(/<script>([\s\S]*?)<\/script>/);
if (!match) { console.error('❌ No se encontró el bloque <script> inline'); process.exit(1); }
fs.writeFileSync('/tmp/ondina_check.js', match[1]);
"
node --check /tmp/ondina_check.js
echo "✅ Sintaxis OK"

echo "📦 Preparando commit..."
git add index.html viewer.html manifest.json apple-touch-icon.png icon-192.png icon-512.png

if git diff --cached --quiet; then
  echo "ℹ️  No hay cambios para desplegar."
  exit 0
fi

MSG="${1:-Deploy $(date '+%Y-%m-%d %H:%M')}"
git commit -m "$MSG"

echo "🚀 Subiendo a GitHub..."
git push origin main

echo "✅ Deploy completo: https://matiasvozzi1980-spec.github.io/ondina-travel/"
