exp_match <- function(exp_code){
  return(as.character(conf$experiments[match(exp_code,conf$exp_codes)]))
}

session_match <- function(exp_code){
  return(as.character(PYA$Session[match(exp_code,PYA$ImageCode)]))
}