#!/bin/bash

postcss --replace --use autoprefixer _site/css/style.css 
cd _site
git add -A
git commit -m "`date`"
git push origin master --force
cd ..
echo "Successfully built and pushed to GitHub."
