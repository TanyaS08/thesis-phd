# From  https://tex.stackexchange.com/questions/40738/how-to-properly-make-a-latex-project
# -----------------------------------------------------------------------------
# You want latexmk to *always* run, because make does not have all the info.
# Also, include non-file targets in .PHONY so they are run regardless of any
# file of the given name existing.
.PHONY: thesis.pdf all clean thesis

# The first rule in a Makefile is the one executed by default ("make"). It
# should always be the "all" rule, so that "make" and "make all" are identical.

all: thesis
thesis: thesis.pdf
md2tex: assets/_article1.tex assets/_introduction.tex

# CUSTOM BUILD RULES
# -----------------------------------------------------------------------------
# In case you didn't know, '$@' is a variable holding the name of the target,
# and '$<' is a variable holding the (first) dependency of a rule.
# "raw2tex" and "dat2tex" are just placeholders for whatever custom steps
# you might have.

# %.tex: %.raw
#         ./raw2tex $< > $@

# %.tex: %.dat
#         ./dat2tex $< > $@


assets/_article1.tex: article1.md
	pandoc --biblatex --filter pandoc-crossref -o assets/_article1.tex article1.md

assets/_introduction.tex: introduction.md
	pandoc --biblatex --filter pandoc-crossref -o assets/_introduction.tex introduction.md

# MAIN LATEXMK RULE
# -----------------------------------------------------------------------------
# -pdf tells latexmk to generate PDF directly (instead of DVI).
# -pdflatex="" tells latexmk to call a specific backend with specific options.
# -use-make tells latexmk to call make for generating missing files.
# -interaction=nonstopmode keeps the pdflatex backend from stopping at a
# missing file reference and interactively asking you for an alternative.

thesis.pdf: thesis.tex introduction.tex article1.tex references.bib assets/_article1.tex assets/_introduction.tex 
	latexmk -f -pdf -pdflatex="pdflatex -interaction=nonstopmode" -use-make thesis.tex

clean:
	@latexmk -c
	@rm -f *.bbl
	@rm -f *.run.xml

rm:
	@latexmk -c
	@rm -f *.bbl
	@rm -f *.run.xml
	rm thesis.pdf
	rm assets/_article1.tex