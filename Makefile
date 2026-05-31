# Define directories
R_SRC_DIR = R
DOCS_SRC_DIR = docs
DATA_DIR = data

# Define targets
R_SCRIPTS = $(wildcard $(R_SRC_DIR)/*.R)
QUARTO_DOCS = $(wildcard $(DOCS_SRC_DIR)/main_*.qmd)
HTML_FILES = $(patsubst %.qmd, %.html, $(QUARTO_DOCS))
RUN_R_FLAG = run_R_done.flag

$(info ************************************)
$(info python source directory:   $(PYTHON_SRC_DIR))
$(info R Source director:         $(R_SRC_DIR))
$(info Docs Source director:      $(DOCS_SRC_DIR))
$(info R scripts:                 $(R_SCRIPTS))
$(info Quarto scripts:            $(QUARTO_DOCS))
$(info HTML files:                $(HTML_FILES))
$(info ************************************)

# Default target
all: run_R slurm_R

# Rule to run the R targets pipeline
run_R:
	@echo "Running R targets pipeline..."
	cd R && Rscript -e "targets::tar_make()"

slurm_R:
	@echo "Running R targets pipeline via slurm..."
	rm -f analysis_*.log
	rm -f analysis_*.stderr
	sbatch analysis.slurm

slurm_docs:
	@echo "Running R render documents pipeline via slurm..."
	rm -f docs_*.log
	rm -f docs_*.stderr
	sbatch docs.slurm

%.html: %.qmd
	@echo "Rendering $< to $@..."
	echo "library(quarto); quarto_render(\"$<\")" | R --no-save --no-restore;

# Rule to render all Quarto documents
render_docs: $(HTML_FILES) $(R_SCRIPTS)
