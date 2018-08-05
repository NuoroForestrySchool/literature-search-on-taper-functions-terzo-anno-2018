# trying (without success) to couple students bib with zotero bib!

get.first.word <- function(l) sapply(strsplit(l, " "), 
                                     function(m) m[1]) %>% tolower()
tibble(zid = names(unlist(zbib$title)), 
       year = as.integer(unlist(zbib$year)), 
       tit1 = get.first.word(unlist(zbib$title)),
       tit = unlist(zbib$title)) %>%
  select(zid)

sbiby <- sbib %>%
  select(ArticleID, field, value) %>%
  filter(field == "PubblicationYear" ) %>%
  mutate(year = as.integer(value)) %>%
  select(-field, -value)

sbib %>%
  select(ArticleID, field, value) %>%
  filter(field == "Title") %>%
  mutate(ArtID = as.integer(ArticleID), 
         tit1 = get.first.word(value), title = value) %>%
  select(-field, -value) %>%
  full_join(sbiby) %>%
  select(ArtID, year, tit1, title) %>%
  as.tibble()
