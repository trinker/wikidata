p_load(wakefield, rvest, XML, parallel, textshape)

r_data_frame()

html()


```library(rvest)
library(magrittr)

x <- "Cat"

rm_empty <- function(x) x[!grepl("^\\s*$", x)]


p_data(qdapDictionaries)
rvest:::make_selector
html_nodes.default <- function (x, css, xpath) {
    xml_find_all(x, make_selector(css, xpath))
}


scrape_wikipedia <- function(x){
    o1 <- try(htmlTreeParse(readLines(sprintf('https://en.wikipedia.org/wiki/%s', x)), useInternalNodes = TRUE))
    if (inherits(o1, "try-error")) return(NA)
    o2<-getNodeSet(o1, "//p//text()")
    o3 <- paste(sapply(o2, xmlValue), collapse = " ")

    gsub("(\\d{2,4})(\\s)(\\d{2,4})", "\\1-\\3", rm_white_multiple(rm_default(rm_square(rm_empty(o3)), pattern="[^ -~]", replace = " ")))
}

scrape_wikipedia_l <- function(y){

    lapply(y, function(x) { try(scrape_wikipedia(x)) })
}

scrape_wikipedia_l(noun_list[[1]][1:30])

grady <- readLines("temp/mobyposi.i")
nouns <- grady[grepl("?N$", grady)]
nouns <- gsub(".{2}$", "", nouns)
nouns <- nouns[!grepl("[^ -~]", nouns)]
nouns <- nouns[grepl("[aeiouy]", nouns)]
nouns <- nouns[!grepl("[^A-Za-z]", nouns)]
nouns <- sort(unique(gsub("(^)([[:alpha:]])", "\\1\\U\\2", nouns, perl=TRUE)))
nouns <- nouns[tolower(nouns) %in% GradyAugmented]

nlen <- length(nouns)

noun_list <- split_index(nouns , seq(100, nlen, by = 100))





nlen <- 100

tic()
noun_list <- lapply(seq_len(nlen), function(i){
    print(sprintf("%s: %s of %s", nouns[i], i, nlen)); flush.console()
    Sys.sleep(.1)
    try(scrape_wikipedia(nouns[i]))
})
toc()

((32378*(46/100))/360)/8

56.56038/100

noun_list2 <- lapply(noun_list[1:4], "[", 1:20)
nouns2 <- nouns[1:400]
nouns2 <- nouns[1:600]

#parallel processing the scrape
cl <- makeCluster(mc <- getOption("cl.cores", detectCores()))
clusterExport(cl=cl, varlist=c("noun_list", "scrape_wikipedia", "scrape_wikipedia_l", "htmlTreeParse", "xmlValue",
    "getNodeSet", "rm_white_multiple", "rm_default", "rm_square", "rm_empty"), envir=environment())

tic()
L1 <- parLapply(cl, noun_list, function(x) {
    Sys.sleep(.1)
    scrape_wikipedia_l(x)
})
toc()

stopCluster(cl) #stop the cluster


saveRDS(L1, file="nouns.rds")


wikipedia_nouns <- Map(function(x, y){
    names(x) <- y
    bind_list(x, "noun", "text")
}, L1, noun_list) %>%
    dplyr::bind_rows() %>%
    filter(!is.na(text) & !(grepl("(can|may) (refer to|mean):", text) & nchar(text) < 250))  %>%
    filter(!(grepl("(can|may|could) (also)?\\s*(refer to|mean)", text) & nchar(text) < 250)) %>%
    filter(!(grepl(":$", text) & nchar(text) < 250)) %>%
    mutate(text = rm_angle(gsub("\\s+(?=(\\.|,))", "", text, perl=TRUE))) %>%
    filter(nchar(text) > 50)

htruncdf(wikipedia_nouns[[1]])

wikipedia_nouns %>% head(20) %>%  select(text) %>% unlist() %>% substring(1, 3000) %>% unname()
nchar(wikipedia_nouns[11, 2])

htruncdf(20, 2000)

wikipedia_nouns %>%
    filter(nchar(text) < 250) %>%
    select(text) %>%
    unlist()%>% unname()

wikipedia_nouns %>%
    #filter(grepl("(can|may) (also )?(refer to|mean):?", text)) %>%
    #filter(grepl("(can|may) also?\\s*(refer to|mean)", text) & nchar(text) < 250) %>%
    filter(nchar(text) < 400) %>%
    select(text) %>%
    unlist()%>% unname() %>%
    paste(collapse="\n\n") %>% cat(file="ff2.txt")


wikipedia_nouns %>%
    filter(grepl(":$", text)) %>%
    select(text) %>%
    unlist()%>% unname() %>%
    paste(collapse="\n") %>% cat(file="ff.txt")



wikipedia <- wikipedia_nouns %>%
    split_sentence()

wikipedia[, noun := tolower(noun),]

wikipedia[["text"]] <- rm_white_multiple(gsub("[^ -~]", " ", wikipedia[["text"]]))

names(wikipedia)[1]

wikipedia[noun == "fish",]


unique(wikipedia[["noun"]])

pack.skel(wikipedia)

set.seed(21)
qdap::htruncdf(data.frame(wikipedia[sort(sample(1:nrow(wikipedia), 7)),]), 7, 100) %>%
    dplyr::mutate(text = ifelse(grepl("\\.$", text), as.character(text), paste0(text, "..."))) %>%
    pander::pander(justify = c('left', 'left', 'right', 'right'))




