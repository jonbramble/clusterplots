exp_match <- function(exp_code){
  return(as.character(conf$experiments[match(exp_code,conf$exp_codes)]))
}

sample_match <- function(sample_code){
  return(as.character(conf$exp_codes[match(sample_code,conf$experiments)]))
}

session_match <- function(exp_code){
  return(as.character(PYA$Session[match(exp_code,PYA$ImageCode)]))
}