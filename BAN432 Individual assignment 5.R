# BAN432 Individual Assignment 5

require(textrank)
require(udpipe)
require(dplyr)
require(readr)
require(stringr)
require(rvest)

aapl <- read_html("aapl_2023-08-03.html")
aapl_text <- html_text(aapl)

# Task 1
tagger <- udpipe_download_model("english")
tagger <- udpipe_load_model("english-ewt-ud-2.5-191206.udpipe")

df <- udpipe_annotate(object = tagger, # Creating a data frame with one word per row
                      x = aapl_text
                      ) %>% 
  as_tibble()

sentences <- df %>% # Creating a data frame with sentence ids and the corresponding sentences
  select(sentence_id, sentence) %>% 
  unique()

terminology <- df %>% # Creating a data frame with only nouns and adjectives and their sentence ids
  filter(upos %in% c("NOUN", "ADJ")) %>% 
  select(sentence_id, lemma)

tr <- textrank_sentences(data = sentences, # Ranking the sentences in order of importance
                         terminology = terminology)

summary(tr, n = 10) # Viewing the top 10 sentences with the highest score


# Task 2
pdf(file = "plot_AAPL.pdf", width = 14, height = 7) # Creating a pdf file with the plot
tr$sentences$textrank %>% 
  barplot(main = "Sentences in the order they appear in the document")
dev.off()
