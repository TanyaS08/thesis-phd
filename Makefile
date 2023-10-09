# From  https://tex.stackexchange.com/questions/40738/how-to-properly-make-a-latex-project
# -----------------------------------------------------------------------------
# You want latexmk to *always* run, because make does not have all the info.
# Also, include non-file targets in .PHONY so they are run regardless of any
# file of the given name existing.
.PHONY: thesis.pdf all clean thesis rm figures

# The first rule in a Makefile is the one executed by default ("make"). It
# should always be the "all" rule, so that "make" and "make all" are identical.

all: thesis figures
thesis: thesis.pdf figures
md2tex: assets/_introduction.tex assets/_article1.tex assets/_conclusion.tex assets/_appendix_joss.tex

# CUSTOM BUILD RULES
# -----------------------------------------------------------------------------
# - '$@' is a variable holding the name of the target
# - '$<' is a variable holding the (first) dependency of a rule.
# - '%' is a placeholder for matching patterns (for targets and dependencies)

# CONVERT FROM MARKDOWN TO LATEX
assets/_%.tex: 0[1-3]_%.md
	pandoc --biblatex --filter pandoc-crossref -o $@ $<

assets/_appendix_joss.tex: ??_appendix_joss.md
	pandoc --biblatex --filter pandoc-crossref --listings -o $@ $<

# MAIN LATEXMK RULE
# -----------------------------------------------------------------------------
# -pdf tells latexmk to generate PDF directly (instead of DVI).
# -pdflatex="" tells latexmk to call a specific backend with specific options.
# -use-make tells latexmk to call make for generating missing files.
# -interaction=nonstopmode keeps the pdflatex backend from stopping at a
# missing file reference and interactively asking you for an alternative.

thesis.pdf: thesis.tex references.bib md2tex figures template/*
	latexmk -f --quiet -pdf -pdflatex="pdflatex -interaction=nonstopmode" -use-make thesis.tex

clean:
	@latexmk -c
	@rm -f *.bbl
	@rm -f *.run.xml

rm:
	@latexmk -c
	@rm -f *.bbl
	@rm -f *.run.xml
	rm thesis.pdf
	rm assets/*.tex
	rm figures/*