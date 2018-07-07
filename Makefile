.PHONY: clean-dist
clean-dist:
	rm -rf dist/
	rm -rf build/
	rm -rf *.egg-info/
	rm -rf .eggs/

.PHONY: clean
clean: clean-dist
	rm -rf `find . -name "__pycache__"`
	rm -f *.pdf

.PHONY: install
install: clean
	python3 -m pip install --upgrade .

dist: clean
	python3 setup.py sdist bdist_wheel

.PHONY: release
release: clean dist
	twine upload dist/*

readme:
	rst2pdf README.rst README.pdf
	open README.pdf
