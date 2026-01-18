const fs = require('fs');
const path = require('path');

console.log('Fixing HTML paths for desktop app...');

const htmlFile = path.join(__dirname, 'out', 'index.html');

if (!fs.existsSync(htmlFile)) {
  console.error('index.html not found in out folder!');
  process.exit(1);
}

// Read the HTML file
let htmlContent = fs.readFileSync(htmlFile, 'utf8');

console.log('Original file size:', htmlContent.length);

// Replace absolute paths with relative paths
const replacements = [
  // CSS and JS files
  { from: /href="\/_next\//g, to: 'href="./_next/' },
  { from: /src="\/_next\//g, to: 'src="./_next/' },
  // Any other absolute paths to assets
  { from: /"\/_next\//g, to: '"./_next/' },
  // Fix any remaining absolute asset paths
  { from: /href="\/([^"]*\.(css|js|png|svg|ico))"/g, to: 'href="./$1"' },
  { from: /src="\/([^"]*\.(css|js|png|svg|ico))"/g, to: 'src="./$1"' }
];

let changeCount = 0;
replacements.forEach((replacement) => {
  const matches = htmlContent.match(replacement.from);
  if (matches) {
    console.log(
      `Found ${matches.length} matches for pattern: ${replacement.from}`
    );
    changeCount += matches.length;
  }
  htmlContent = htmlContent.replace(replacement.from, replacement.to);
});

// Write the fixed HTML file
fs.writeFileSync(htmlFile, htmlContent);

console.log(`Fixed ${changeCount} path references in ${htmlFile}`);
console.log('Fixed file size:', htmlContent.length);
console.log('HTML paths fixed successfully!');
