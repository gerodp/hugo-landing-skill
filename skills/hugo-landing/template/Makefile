run:
	hugo server --buildDrafts --noHTTPCache --disableFastRender

build:
	hugo --gc --minify

new-post:
	hugo new content $(CP)

publish:
	find content -name "*.md" -type f -exec perl -pi -e 's/draft = true/draft = false/g' {} \;

clean:
	rm -rf public resources/_gen && echo "Build output and image cache cleared"

lint:
	npm run lint

help:
	@echo "Available commands:"
	@echo "  make run       - Start development server"
	@echo "  make build     - Production build (minified)"
	@echo "  make new-post CP=content/en/blog/my-post.md - Create new content"
	@echo "  make publish   - Remove draft status from all posts"
	@echo "  make lint      - Run JS/CSS/HTML linters"
	@echo "  make clean     - Clear build output and image cache"

.PHONY: run build new-post publish clean lint help
