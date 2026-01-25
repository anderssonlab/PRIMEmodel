#!/usr/bin/env Rscript

suppressWarnings(suppressMessages({
  library(argparse)
  library(CAGEfightR)
  library(GenomicRanges)
  library(PRIME)
  library(PRIMEmodel)
  library(assertthat)
}))

### ARGPARSE
parser <- ArgumentParser()

# Input
parser$add_argument("--bed_path", required = TRUE,
                    help = "FULL PATH to input bed file preparing for PRIMEmodel focal") # nolint: line_length_linter.

# Parameters
parser$add_argument("-e", "--ext_dis", default = 200,
                    help = "Extension distance")

args <- parser$parse_args()

# Setting up variables
ext_dis <- as.integer(args$ext_dis)
len_vec <- ext_dis * 2 + 1

plc_message("🚀 Running PRIMEmodel -7: prepare postprocessed bed for PRIMEmodel focal input") # nolint: line_length_linter.

bed_path <- args$bed_path
bed_data <- utils::read.delim(bed_path,
                              header = FALSE,
                              stringsAsFactors = FALSE)
bed_colnames <- c("chrom", "chromStart", "chromEnd",
                  "name", "score", "strand",
                  "thickStart", "thickEnd")
colnames(bed_data) <- bed_colnames

gr <- PRIMEmodel::plc_create_granges_from_bed(bed_data)

if (all(GenomicRanges::width(gr) != len_vec)) {
  msg <- paste("⚠️ All regions in the object (GRanges) must have width",
               len_vec,
               " : extend 401 bp from thick if existed. It was saved as an extended object.") # nolint: line_length_linter.
  region_gr <- PRIMEmodel::plc_extend_fromthick(tc_gr = gr,
                                                ext_dis = ext_dis)
  saveRDS(region_gr, file = paste0(tools::file_path_sans_ext(bed_path), # nolint: line_length_linter.
                                   "_extfromthick.rds"))

} else {
  msg <- paste("✅ All regions in the object (GRanges) have width", len_vec) # nolint: line_length_linter.
}
plc_message(msg)
