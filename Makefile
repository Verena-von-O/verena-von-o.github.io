SHELL := /bin/bash

default: clean serve

clean:
	rm -rf _site

build:
	bundle exec jekyll build

serve:
	bundle exec jekyll serve --config _config.yml,_config-dev.yml