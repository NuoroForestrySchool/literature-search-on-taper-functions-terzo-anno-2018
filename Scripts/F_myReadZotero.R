myReadZotero <- function (user, group, .params, temp.file = tempfile(fileext = ".bib"), 
          delete.file = TRUE) 
{
  if (delete.file) 
    on.exit(unlink(temp.file, force = TRUE))
  bad.ind <- which(!names(.params) %in% c("q", "itemType", 
                                          "tag", "collection", "key", "limit", "start", "qmode"))
  .parms <- .params
  if (length(bad.ind)) {
    warning("Invalid .params specified and will be ignored")
    .parms <- .parms[-bad.ind]
  }
  .parms$format <- "bibtex"
  if (is.null(.parms$limit)) 
    .parms$limit <- 99L
  coll <- if (is.null(.parms$collection)) 
    NULL
  else paste0("/collections/", .parms$collection)
  .parms$uri <- paste0("https://api.zotero.org/", if (!missing(user)) 
    paste0("users/", user)
    else paste0("groups/", group), coll, "/items")
  uri <- paste0("https://api.zotero.org/", if (!missing(user)) 
    paste0("users/", user)
    else paste0("groups/", group), coll, "/items")
  print(uri)
  print(.parms)
  res <- RefManageR::GET(uri, query = .parms)
  res <- rawToChar(res$content)
  if (.is_not_nonempty_text(res)) {
    print("No results.")
    return()
  }
  write(res, file = temp.file, append = TRUE)
  bib.res <- try(ReadBib(file = temp.file, .Encoding = "UTF-8"), 
                 TRUE)
  if (inherits(bib.res, "try-error")) {
    stop(gettextf("Could not parse the returned BibTeX results.  If %s %s%s", 
                  sQuote("delete.file"), "is FALSE, you can try viewing and editing the file: ", 
                  temp.file))
  }
  bib.res
}