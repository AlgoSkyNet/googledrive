context("dplyr compatibility")

# ---- other ----
if (FALSE) {
  ## how the test file was created
  saveRDS(
    drive_find(n_max = 10),
    test_file("just_a_dribble.rds")
  )
}

# ---- tests ----
test_that("dribble class can be retained by dplyr verbs", {
  skip_if_not_installed("dplyr")

  x <- readRDS(test_file("just_a_dribble.rds"))

  expect_s3_class(dplyr::arrange(x, name), "dribble")
  expect_s3_class(dplyr::filter(x, grepl("-TEST-", name)), "dribble")
  expect_s3_class(dplyr::mutate(x, a = "a"), "dribble")
  expect_s3_class(dplyr::slice(x, 3:4), "dribble")

  x_augmented <- dplyr::mutate(x, new = name)
  expect_s3_class(dplyr::rename(x_augmented, new2 = new), "dribble")
  expect_s3_class(dplyr::select(x_augmented, name, id, drive_resource), "dribble")
})

test_that("dribble class can be dropped by dplyr verbs", {
  skip_if_not_installed("dplyr")

  x <- readRDS(test_file("just_a_dribble.rds"))

  expect_false(inherits(dplyr::mutate(x, name = 1L), "dribble"))
  expect_false(inherits(dplyr::rename(x, HEY = name), "dribble"))
  expect_false(inherits(dplyr::select(x, name, id), "dribble"))
})
