#' Get/set time zone component of a date-time
#'
#' @description
#' Conveniently get and set the time zone of date-time, with convenient
#' fallback behaviour for dates. Note that modifying the time does not change
#' the instant in time represented by the vector, just its printed
#' representation. Use [with_tz()] if need the same time (i.e. a different
#' instant) in another time zone.
#'
#' @section Valid time zones:
#' Time zones are stored in system specific database, so are not guaranteed
#' to be the same on every system (however, they are usually pretty similar
#' unless your sytsem is very out of date). You can see a complete list with
#' [OlsonNames()]
#'
#' @export
#' @param x A date-time vector, usually of class POSIXct or POSIXlt.
#' @return A character vector of length 1, giving the time zone of the vector.
#'   An empty string (`""`) represents the current/default timezone.
#'
#'   For backward compatibility, the time zone of a date, `NA`, or
#'   character vector is `"UTC"`.
#' @seealso See [DateTimeClasses] for a description of the underlying
#'   `tzone` attribute..
#' @keywords utilities manip chron methods
#' @examples
#' x <- ymd("2012-03-26", tz = "UTC")
#' tz(x)
#'
#' tz(x) <- "GMT"
#' x
tz <- function(x) {
  UseMethod("tz")
}

#' @export
tz.POSIXt <- function(x) {
  tzone <- attr(x, "tzone")
  if (is.null(tzone)) {
    ""
  } else {
    tzone[[1]]
  }
}

#' @export
tz.Date <- function(x) {
  # warning("Dates do not have timezones", call. = FALSE)
  "UTC"
}

#' @export
tz.character <- function(x) {
  "UTC"
}

#' @export
tz.logical <- function(x) {
  if (all(is.na(x))) {
    "UTC"
  } else {
    NextMethod()
  }
}

#' @export
tz.default <- function(x) {
  stop(
    "Don't know how to compute timezone for object of class ",
    paste0(class(x), collapse = "/"),
    call. = FALSE
  )
}

#' @export
tz.zoo <- function(x) {
  tz(zoo::index(x))
}

#' @export
tz.timeSeries <- function(x) {
  tz(x@FinCenter)
}

#' @rdname tz
#' @param value New value to use for time zone.
#' @export
"tz<-" <- function(x, value) {
  force_tz(x, value)
}
