###############################################################
#   GNU MAKEFILE FOR COMPETENCY ASSESSMENT ANALYSIS           #
#   derived from the work of Rob Hyndman                      #
#   http://robjhyndman.com/hyndsight/makefiles/               #
#                                                             #
#   Dr. Clifton Franklund                                     #
#   Ferris State University                                   #
#   April 2015                                                #
###############################################################

#   Define some important variables first
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# The final document (goal)
TEXFILE= report

# Main directories in use
RDIR= ./R
FIGDIR= ./figs
DATADIR= ./data
CLEANDATADIR= ./processed
DOCDIR= ./doc

# list of data files
DATAFILES := $(wildcard $(DATADIR)/*.xlsx)

# list R files
RFILES := $(wildcard $(RDIR)/*.R)

# pdf figures created by R
PDFFIGS := $(wildcard $(FIGDIR)/*.pdf)

# Indicator files to show R file has run
OUT_FILES:= $(RFILES:.R=.Rout)

# Indicator files to show pdfcrop has run
CROP_FILES:= $(PDFFIGS:.pdf=.pdfcrop)

# Datafile README present
DATA_README = ./data/README.md


#   Specify various targets for make
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

all: $(TEXFILE).pdf $(OUT_FILES) $(CROP_FILES)

# May need to add something here if some R files depend on others.

# RUN EVERY R FILE
$(RDIR)/%.Rout: $(RDIR)/%.R $(RDIR)/functions.R
	Rscript $<

# CROP EVERY PDF FIG FILE
$(FIGDIR)/%.pdfcrop: $(FIGDIR)/%.pdf
	pdfcrop $< $< && touch $@

# Compile main tex file
$(TEXFILE).pdf: $(TEXFILE).tex $(OUT_FILES) $(CROP_FILES)
	latexmk -pdf -quiet $(TEXFILE)

# Run R files
R: $(OUT_FILES)

# View main tex file
view: $(DOCDIR)/$(TEXFILE).pdf
	open $(DOCDIR)/$(TEXFILE).pdf &

# Aggregate the data
$(CLEANDATADIR)/cleanData.rds: $(DATADIR) $(RDIR)/aggregate.R
	Rscript $(RDIR)/aggregate.R

# Load, tidy up, and sanitize the raw data
dataset: $(CLEANDATADIR)/cleanData.rds

# Remove any files with identifying information before distribution
ferpa:
ifeq ($(wildcard $(DATA_README)),)
	echo "##Data files have been deleted  " > $(DATADIR)/README.md
	echo "To comply with the requirements of the Family Educational Rights and Privacy Act, \
	[FERPA](http://www2.ed.gov/ferpa/), all data files containing identifying personal \
	information have been removed from this project. For the record, the names of all the files \
	that were included in this analysis are provided below.  \n" >> $(DATADIR)/README.md
	echo $(notdir $(DATAFILES)) >> $(DATADIR)/README.md
	rm -fv $(DATADIR)/*.xlsx
	rm -fv $(RDIR)/sanitize.R
endif

# Remove all generated files except the clean dataset
clean:
	rm -fv $(OUT_FILES)
	rm -fv $(CROP_FILES)
	rm -fv *.aux *.log *.toc *.blg *.bbl *.synctex.gz *.out *.bcf *blx.bib *.run.xml
	rm -fv *.fdb_latexmk *.fls
	rm -fv $(TEXFILE).pdf

# Remove all generated files and rebuild them from scratch
rebuild:
	clean all

.PHONY: all clean dataset ferpa rebuild
