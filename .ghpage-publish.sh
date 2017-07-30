npm run build
git checkout gh-pages
cp -a dist/. .
git add .
git commit -m "Published"
git push origin gh-pages
