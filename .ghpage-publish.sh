npm run build
cp -a ./dist ./
git add .
git commit -m "Published"
git push origin gh-pages
