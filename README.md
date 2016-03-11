wikidata
============


[![Build
Status](https://travis-ci.org/trinker/wikidata.svg?branch=master)](https://travis-ci.org/trinker/wikidata)
[![Coverage
Status](https://coveralls.io/repos/trinker/wikidata/badge.svg?branch=master)](https://coveralls.io/r/trinker/wikidata?branch=master)
<a href="https://img.shields.io/badge/Version-0.0.1-orange.svg"><img src="https://img.shields.io/badge/Version-0.0.1-orange.svg" alt="Version"/></a>
</p>
<img src="inst/wikidata_logo/wiki.png" width="250" alt="wikipedia data">

**wikidata** is a corpus (`data.frame` format) of
[Wikipedia](https://www.wikipedia.org/) articles scraped from a noun
list search.


Table of Contents
============

-   [[Variables](#variables)](#[variables](#variables))
-   [[Sample Slice](#sample-slice)](#[sample-slice](#sample-slice))
-   [[Lookup](#lookup)](#[lookup](#lookup))
-   [[Installation](#installation)](#[installation](#installation))
-   [[Contact](#contact)](#[contact](#contact))

Variables
============


-   `noun`: The noun used to search for the Wikipedia article.
-   `text`: The text from the article.
-   `element_id`: The article number.
-   `sentence_id`: The sentence within the `element_id`.

Sample Slice
------------

<table style="width:97%;">
<colgroup>
<col width="18%" />
<col width="43%" />
<col width="18%" />
<col width="18%" />
</colgroup>
<thead>
<tr class="header">
<th align="left">noun</th>
<th align="left">text</th>
<th align="right">element_id</th>
<th align="right">sentence_id</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td align="left">Bezique</td>
<td align="left">The game is derived from Piquet, possibly via Marriage (Sixty-six) and Briscan, with additional scor...</td>
<td align="right">1781</td>
<td align="right">2</td>
</tr>
<tr class="even">
<td align="left">Chromium</td>
<td align="left">Several in vitro studies indicated that high concentrations of chromium(III) in the cell can lead to...</td>
<td align="right">3310</td>
<td align="right">210</td>
</tr>
<tr class="odd">
<td align="left">Dengue</td>
<td align="left">In severe disease, plasma leakage results in hemoconcentration (as indicated by a rising hematocrit ...</td>
<td align="right">4611</td>
<td align="right">113</td>
</tr>
<tr class="even">
<td align="left">Pigment</td>
<td align="left">wherein they have created plastic swatches on website by 3D modelling to including various special e...</td>
<td align="right">12764</td>
<td align="right">136</td>
</tr>
<tr class="odd">
<td align="left">Rutabaga</td>
<td align="left">The roots and tops are used as winter feed for livestock.</td>
<td align="right">14368</td>
<td align="right">76</td>
</tr>
<tr class="even">
<td align="left">Toxicologist</td>
<td align="left">Toxicologists perform many more duties including research in the academic, nonprofit and industrial ...</td>
<td align="right">16861</td>
<td align="right">42</td>
</tr>
<tr class="odd">
<td align="left">Vinery</td>
<td align="left">However, in the late 19th century, the entire species was nearly destroyed by the plant louse phyllo...</td>
<td align="right">17578</td>
<td align="right">10</td>
</tr>
</tbody>
</table>

Lookup
======

    if (!require("pacman")) install.packages("pacman")
    pacman::p_load_gh('trinker/wikidata')
    pacman::p_load(data.table, stringdist)


    wiki_look <- function(x, method = 'osa', cutoff = 3, ...){
        vals <- stringdist::stringdist(
            SnowballC::wordStem(tolower(wikipedia[["noun"]])), 
            SnowballC::wordStem(tolower(x)), 
            method
        )
        if (min(vals) > cutoff) stop('No nouns meet the cutoff')
        word <- as.character(wikipedia[which.min(vals), "noun", with=FALSE])
        wikipedia[noun %in% word,]
    }

    wiki_look('dog')
    wiki_look('dog')[, .(text = paste(text, collapse = " ")), by = c('noun')]

Installation
============

To download the development version of **wikidata**:

Download the [zip
ball](https://github.com/trinker/wikidata/zipball/master) or [tar
ball](https://github.com/trinker/wikidata/tarball/master), decompress
and run `R CMD INSTALL` on it, or use the **pacman** package to install
the development version:

    if (!require("pacman")) install.packages("pacman")
    pacman::p_load_gh("trinker/wikidata")

Contact
=======

You are welcome to:   
* submit suggestions and bug-reports at: <https://github.com/trinker/wikidata/issues>   
* send a pull request on: <https://github.com/trinker/wikidata/> 
*

compose a friendly e-mail to: <tyler.rinker@gmail.com>