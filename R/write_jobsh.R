#' Write a simple job.sh for local OpenSimRoot execution
#'
#' @param rundir path to directory where run will happen
#' @param outdir path to which PEcAn-relevant output should be copied after run.
#'  Not used yet -- haven't decided what to copy
#' @param infile path to XML OpenSimRoot input file
#' @param bin path to OpenSimRoot binary
#'
#' @return nothing; writes file as side effect
#' @keywords internal
#' @examples \dontrun{
#'    osrdir = file.path(tempdir(), "demo")
#'    write_jobsh(
#'      file.path(osrdir, "run"),
#'      file.path(osrdir, "out"),
#'      infile = "./example.xml",
#'      binpath = "/usr/bin/OpenSimRoot")
#'  }
write_jobsh <- function(rundir, outdir, infile, bin="~/bin/OpenSimRoot") {
  cat("#!/bin/bash\n\n",
    "set -e\n",
    "cd ", rundir, "\n",
    "RUNTIME=`date +%s`\n\n",
    "(time ", bin, " ", infile, ") >log_${RUNTIME}.txt 2>&1\n",
    "cd ", outdir, "\n",
    "cp ", file.path(rundir, "README.txt"), " ", file.path(outdir, "README.txt"), "\n",
    sep = "",
    file = file.path(rundir, "job.sh"))
}

#' Write a Torque script to run OpenSimRoot on the PSU computing cluster
#'
#' Produces a script that submits one single model as its own job.
#' This means if you have a batch of models to run,
#' you'll have to submit each one separately,
#' which is (1) a pain, and (2) kind of defeats the point of a batch job.
#' TODO: improve this.
#'
#' @inheritParams write_jobsh
#' @return nothing; writes file as side effect
#' @keywords internal
write_aci_jobsh <- function(rundir, outdir, infile, bin="~/bin/OpenSimRoot"){
  cat("#!/bin/bash\n\n",
    "#PBS -A open\n",
    "#PBS -l nodes=1:ppn=1\n",
    "#PBS -l walltime=06:00:00\n",
    "#PBS -l pmem=12gb\n",
    "#PBS -j oe\n\n",
    "set -e\n",
    "cd $PBS_O_WORKDIR\n",
    "RUNTIME=`date +%s`\n\n",
    "(time ", bin, " ", infile, ") >log_${RUNTIME}.txt 2>&1\n",
    "cp ", file.path(rundir, "README.txt"), " ", file.path(outdir, "README.txt"), "\n",
    sep = "",
    file = file.path(rundir, "job.sh"))
}
