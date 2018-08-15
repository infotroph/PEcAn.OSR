#' Writes a configuration file and run scripts for OpenSimRoot
#'
#' This function edits the specified set of OpenSimRoot default parameters by
#'  updating traits to the values specified in `trait.samples`,
#'  then writes the result to a single set of configuration files for one
#'  invocation of OpenSimRoot, e.g. one ensemble member.
#'  Since most model runs involve multiple ensemble members, `write.config.OSR`
#'  will usually be called by [PEcAn.uncertainty::write.ensemble.configs()]
#'  rather than invoked directly by the user.
#'
#' @param defaults list of PFTs to be simulated.
#'  each PFT must have an element named `path`
#' @param trait.values list or dataframe of trait values to use for this run.
#'  Traits must be named according to PEcAn standard and will be converted
#'  internally to OSR variable names.
#' @param settings settings from PEcAn settings file
#' @param run.id integer; a unique identifier for the run.
#'
#' @return path to the directory where configurations were saved
#'  (TODO: Is this actually a useful value to return?)
#'
#' @export
write.config.OSR <- function(defaults, trait.values, settings, run.id) {

  rundir <- file.path(settings$host$rundir, run.id)
  dir.create(rundir, recursive = TRUE)

  outdir <- file.path(settings$host$outdir, run.id)
  dir.create(outdir, recursive = TRUE)

  # TODO: handle multiple PFTs here
  config <- XML::xmlParse(defaults$pft$path)

  # replace traits here

  # transfer settings here

  config_path <- file.path(rundir, "config.xml")
  XML::saveXML(doc = config, file = config_path)
  write_jobsh(
    rundir = rundir,
    outdir = outdir,
    infile = config_path,
    bin = settings$model$binary)

  return(rundir)
}
