#!/bin/sh

echo "1. Clearing public folder"
rm -rf public/*

echo "\n2. Generating site"
hugo

echo "\n3. Publishing to GitHub Pages"
cd public
git add --all
git commit -m "Published $(date)"
git push origin gh-pages
cd ..