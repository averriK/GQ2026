# nolint start
readFile <- function(file, hint, readFun, ...) {
  if (!file.exists(file)) stop(paste0("Missing data: ", basename(file), ". ", hint))
  readFun(file, ...)
}

.fmt <- function(x, d = 2) formatC(x, format = "f", digits = d)

.fmti <- function(x) formatC(x, format = "d", big.mark = ",")

.convertKmax <- function(x, units) {
  if (units %in% c("cm", "cm/s2", "cm/s**2", "cm/s^2")) round(x * 988, 0)
  else if (units == "g") round(x, 3)
  else x
}
# nolint end
