#' Wikipedia Noun Articles
#'
#' A dataset containing wikipedia articles searched for via a nouns data base.
#'
#' @details
#' \itemize{
#'   \item noun. The noun used to search for the Wikipedia article.
#'   \item text. The text from the article.
#'   \item element_id. The article number.
#'   \item sentence_id. The sentence within the \code{element_id}.
#' }
#'
#' @docType data
#' @keywords datasets
#' @name wikipedia
#' @usage data(wikipedia)
#' @format A data frame with 1,403,063 rows and 4 variables
#' @references \url{https://en.wikipedia.org}
#' @example
#' \dontrun{
#' if (!require("pacman")) install.packages("pacman")
#' pacman::p_load_gh('trinker/wikidata')
#' pacman::p_load(data.table, stringdist)
#'
#' wiki_look <- function(x, method = 'osa', cutoff = 3, ...){
#'     vals <- stringdist::stringdist(
#'         SnowballC::wordStem(tolower(wikipedia[["noun"]])),
#'         SnowballC::wordStem(tolower(x)),
#'         method
#'     )
#'     if (min(vals) < cutoff) stop('No nouns meet the cutoff')
#'     word <- as.character(wikipedia[which.min(vals), "noun", with=FALSE])
#'     wikipedia[noun %in% word,]
#' }
#'
#' wiki_look('dog')
#' wiki_look('dog')[, .(text = paste(text, collapse = " ")), by = c('noun')]
#' }
NULL
