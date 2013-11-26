# Build, package and clean Fatiando
PY := python
PIP := pip
NOSE := nosetests

help:
	@echo "Commands:"
	@echo ""
	@echo "    build         build the extension modules inplace"
	@echo "    docs          build the html documentation"
	@echo "    docs-pdf      build the pdf documentation"
	@echo "    view-docs     show the html docs on firefox"
	@echo "    test          run the test suite (including doctests)"
	@echo "    deps          installs development requirements"
	@echo "    package       create source distributions"
	@echo "    clean         clean up"
	@echo ""

build:
	$(PY) setup.py build_ext --inplace

cython:
	$(PY) setup.py build_ext --inplace --cython

docs: clean
	cd doc; make html

docs-pdf: clean
	cd doc; make latexpdf

view-docs:
	firefox doc/_build/html/index.html &

test:
	$(NOSE) fatiando/ --with-doctest -v
	$(NOSE) test/ -v

test-docs:
	$(NOSE) fatiando/ --with-doctest -v

package: docs-pdf
	$(PY) setup.py sdist --formats=zip,gztar

upload:
	python setup.py register sdist --formats=zip,gztar upload

clean:
	find . -name "*.so" -exec rm -v {} \;
	#find "fatiando" -name "*.c" -exec rm -v {} \;
	find . -name "*.pyc" -exec rm -v {} \;
	rm -rvf build dist MANIFEST
	# Trash generated by the doctests
	rm -rvf mydata.txt mylogfile.log
	# The stuff fetched by the cookbook recipes
	rm -rvf logo.png cookbook/logo.png
	rm -rvf crust2.tar.gz cookbook/crust2.tar.gz

clean-docs:
	cd doc; make clean
