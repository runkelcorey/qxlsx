getback <- function(url, adoption) {
  wb <- httr::content(httr::GET(paste0("http://archive.org/wayback/available?url=", url, "&timestamp=", str_remove_all(adoption, "-"))), as = "parsed")
  if (length(wb[["archived_snapshots"]]) == 0) {
    return(NA)
  }
  else if (any(adoption - as.Date(substr(wb[["archived_snapshots"]][["closest"]][["timestamp"]], 1, 8), format = "%Y%m%d") > 2, adoption - as.Date(substr(wb[["archived_snapshots"]][["closest"]][["timestamp"]], 1, 8), format = "%Y%m%d") < -10)) {
    return(NA)
  }
  else {
    return(wb[["archived_snapshots"]][["closest"]][["url"]])
  }
}