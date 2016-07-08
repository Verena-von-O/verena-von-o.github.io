SHELL := /bin/bash

default: precheck clean serve

precheck:
	@type postcss

clean:
	rm -rf _site/css 
	rm -rf _site/de
	rm -rf _site/en
	rm _site/*.xml
	rm _site/*.html

build:
	bundle exec jekyll build

serve:
	bundle exec guard

publish: precheck clean
	bundle exec jekyll build
	postcss --replace --use autoprefixer _site/css/style.css 
	cd _site
	git add -A
	git commit -m "`date`"
	git push origin master --force
	cd ..
	echo "Successfully built and pushed to GitHub."
