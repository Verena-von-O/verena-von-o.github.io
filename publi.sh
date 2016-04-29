#!/bin/bash

bundle exec jekyll build
postcss --replace --use autoprefixer _site/css/style.css 
cd _site
git add -A
git commit -m "`date`"
git push origin master
cd ..
echo "Successfully built and pushed to GitHub."
