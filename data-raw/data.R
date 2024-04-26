library(tidyverse)

wells <-
  tidyr::expand_grid(x = LETTERS[1:8], y = 1:12) |>
  dplyr::mutate(well = paste0(x, y)) |>
  dplyr::pull(well)

sample_names <- paste0("S", 1:4)

# NB: We assign the `plate` values after the `amplicon` because each plate was
# used for one amplicon (gene).
pivot <- function(tbl, amplicon) {
  tbl |>
    tidyr::pivot_longer(cols = -1L,
                        names_to = "well",
                        values_to = "fluor") |>
    dplyr::transmute(
      plate = amplicon,
      well = rep(wells[seq_len(ncol(tbl) - 1L)], 40),
      target = plate,
      cycle = `Cycle No.`,
      fluor
    )
}

# First layout:
# Sample (n = 4), replicate (n = 5), dilution (n = 4)
# At the end, three NTC replicates.
layout <-
  tidyr::expand_grid(
    dye = "SYBR",
    sample = sample_names,
    sample_type = "std",
    replicate = as.character(1:5),
    copies = NA_integer_,
    dilution = c(1L, 10L, 50L, 100L)
  ) |>
  dplyr::bind_rows(
    tibble::tibble(
      sample = NA_character_,
      sample_type = "ntc",
      replicate = as.character(1:3),
      copies = rep(0L, 3L),
      dilution = NA_integer_
    )
  ) |>
  tibble::rowid_to_column(var = "well") |>
  dplyr::mutate(well = wells[1:83])

sample2 <- rep(sample_names, each = 24)

dilution2 <-
  rep(c(
    rep(c(1L, 10L), each = 5),
    rep(1000L, each = 2),
    rep(c(50L, 100L), each = 5),
    rep(1000L, each = 2)
  ), 4)

replicate2 <- rep(rep(c(1:5, 1:5, 1:2), 2), 4)


# Second layout:
# Sample (n = 4)
# Dilutions: 1, 10, 50, 100 and 1000.
# Replicates: Five replicates for dilution = {1, 10, 50, 100} and two replicates
# for dilution = 1000.
# No NTCs included in this layout.
layout2 <-
  tibble::tibble(
    dye = "SYBR",
    sample = as.character(sample2),
    sample_type = "std",
    replicate = as.character(replicate2),
    copies = NA_integer_,
    dilution = dilution2
  ) |>
  dplyr::mutate(well = wells)

path <- here::here("data-raw/")
raw_data_cav <-
  readxl::read_excel(file.path(path, "Cav.xls"),
                     sheet = "Cav 240602 clipped",
                     range = "C1:CH41")

raw_data_ctgf <-
  readxl::read_excel(file.path(path, "CTGF.xls"),
                     sheet = "CTGF clipped",
                     range = "C1:CU41")

raw_data_eln <-
  readxl::read_excel(file.path(path, "Elastin.xls"),
                     sheet = "080702 Clipped",
                     range = "C1:CH41")

raw_data_fn <-
  readxl::read_excel(file.path(path, "FN.xls"),
                     sheet = "FN Clipped",
                     range = "C1:CU41")

raw_data_L27_1 <-
  readxl::read_excel(file.path(path, "L27 (1).xls"),
                     sheet = "L27 Clipped",
                     range = "C1:CU41")

raw_data_L27_2 <-
  readxl::read_excel(file.path(path, "L27 (2).xls"),
                     sheet = "Clipped",
                     range = "C1:CU41")

raw_data_perl <-
  readxl::read_excel(file.path(path, "Perl.xls"),
                     sheet = "Clipped",
                     range = "C1:CH41")

raw_data_pai1 <-
  readxl::read_excel(file.path(path, "PAI1.xls"),
                     sheet = "Clipped 0.1",
                     range = "A1:CG41")

data_cav <-
  pivot(raw_data_cav, "CAV") |>
  dplyr::left_join(layout, by = "well") |>
  dplyr::relocate(cycle, fluor, .after = dplyr::last_col()) |>
  dplyr::arrange(plate, sample, dilution, replicate, cycle)

data_ctgf <-
  pivot(raw_data_ctgf, "CTGF") |>
  dplyr::left_join(layout2, by = "well") |>
  dplyr::relocate(cycle, fluor, .after = dplyr::last_col()) |>
  dplyr::arrange(plate, sample, dilution, replicate, cycle)

data_eln <-
  pivot(raw_data_eln, "ELN") |>
  dplyr::left_join(layout, by = "well") |>
  dplyr::relocate(cycle, fluor, .after = dplyr::last_col()) |>
  dplyr::arrange(plate, sample, dilution, replicate, cycle)

data_L27_1 <-
  pivot(raw_data_L27_1, "L27_1") |>
  dplyr::left_join(layout2, by = "well") |>
  dplyr::relocate(cycle, fluor, .after = dplyr::last_col()) |>
  dplyr::arrange(plate, sample, dilution, replicate, cycle)

data_L27_2 <-
  pivot(raw_data_L27_2, "L27_2") |>
  dplyr::left_join(layout2, by = "well") |>
  dplyr::relocate(cycle, fluor, .after = dplyr::last_col()) |>
  dplyr::arrange(plate, sample, dilution, replicate, cycle)

data_fn <-
  pivot(raw_data_fn, "FN") |>
  dplyr::left_join(layout2, by = "well") |>
  dplyr::relocate(cycle, fluor, .after = dplyr::last_col()) |>
  dplyr::arrange(plate, sample, dilution, replicate, cycle)

data_perl <-
  pivot(raw_data_perl, "Perl") |>
  dplyr::left_join(layout, by = "well") |>
  dplyr::relocate(cycle, fluor, .after = dplyr::last_col()) |>
  dplyr::arrange(plate, sample, dilution, replicate, cycle)

data_pai1 <-
  pivot(raw_data_pai1, "PAI1") |>
  dplyr::left_join(layout, by = "well") |>
  dplyr::relocate(cycle, fluor, .after = dplyr::last_col()) |>
  dplyr::arrange(plate, sample, dilution, replicate, cycle)

karlen <-
  dplyr::bind_rows(
    data_cav,
    data_ctgf,
    data_eln,
    data_L27_1,
    data_L27_2,
    data_fn,
    data_perl,
    data_pai1
  ) |>
  dplyr::mutate(
    plate = as.factor(plate),
    well = factor(well, levels = wells),
    target = as.factor(target),
    dye = as.factor(dye),
    sample = as.factor(sample),
    sample_type = as.factor(sample_type),
    replicate = as.factor(replicate)
  )

usethis::use_data(karlen, overwrite = TRUE)
