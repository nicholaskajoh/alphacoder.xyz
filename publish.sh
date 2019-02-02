#!/bin/sh

echo "1. Generating site"
hugo

echo "\n2. Publishing to GitHub Pages"
cd public
git add --all
git commit -m "Published $(date)"
git push origin gh-pages
cd ..