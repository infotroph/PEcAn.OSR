
context("write configs")

testdir <- tempfile()
dir.create(testdir)
teardown({
  unlink(testdir)
})

test_that("writes files to correct path", {

  run_id <- 1
  defaults_path <- file.path(testdir, "test_defaults.xml")
  run_path <- file.path(testdir, "run")
  out_path <- file.path(testdir, "out")

  XML::saveXML(
    doc = XML::xmlParse("<xml><some_trait>3.14</some_trait></xml>"),
    file = defaults_path)

  res <- write.config.OSR(
    defaults = list(pft = list(name = "fake", path = defaults_path)),
    trait.values = NULL,
    settings = list(
      host = list(rundir = run_path, outdir = out_path),
      model = list(binary = "/fake/path/to/OpenSimRoot")),
    run.id = run_id)

  expect_equal(res, file.path(run_path, run_id))

  expect_true(dir.exists(file.path(run_path, run_id)))
  expect_true(dir.exists(file.path(out_path, run_id)))
  expect_true(file.exists(file.path(run_path, run_id, "config.xml")))
  expect_true(file.exists(file.path(run_path, run_id, "job.sh")))
})
