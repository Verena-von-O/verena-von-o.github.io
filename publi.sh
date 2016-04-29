# Publish site to gh-pages branch
# 
# Build using jekyll
# run postcss with autoprefix
#
git checkout gh-pages
rm -rf _site/
bundle exec jekyll build
postcss --replace --use autoprefixer _site/css/style.css 
git add --all
git commit -m "`date`"
git push origin gh-pages
git push origin `git subtree split --prefix _site/ master`:gh-pages --force
git checkout master