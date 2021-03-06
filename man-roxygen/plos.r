#' @param q Search terms (character). You can search on specific fields by
#' doing 'field:your query'. For example, a real query on a specific field would
#' be 'author:Smith'.
#' @param fl Fields to return from search (character) [e.g., 'id,title'],
#' any combination of search fields (see the dataset \code{plosfields})
#' @param fq List specific fields to filter the query on (if NA, all queried).
#' The options for this parameter are the same as those for the fl parameter.
#' Note that using this parameter doesn't influence the actual query, but is used
#' to filter the results to a subset of those you want returned. For example,
#' if you want full articles only, you can do \code{'doc_type:full'}. In another example,
#' if you want only results from the journal PLOS One, you can do
#' \code{'journal_key:PLoSONE'}. See \code{\link{journalnamekey}} for journal
#' abbreviations.
#' @param sort Sort results according to a particular field, and specify ascending (asc)
#' or descending (desc) after a space; see examples. For example, to sort the
#' counter_total_all field in descending fashion, do sort='counter_total_all desc'
#' @param start Record to start at (used in combination with limit when
#' you need to cycle through more results than the max allowed=1000). See Pagination
#' below
#' @param limit Number of results to return (integer). Setting \code{limit=0} returns only
#' metadata. See Pagination below
#' @param sleep Number of seconds to wait between requests. No need to use this for
#' a single call to searchplos. However, if you are using searchplos in a loop or
#' lapply type call, do sleep parameter is used to prevent your IP address from being
#' blocked. You can only do 10 requests per minute, so one request every 6 seconds is
#' about right.
#' @param ... Additional Solr arguments
#' @param callopts (list) optional curl options passed to \code{\link[crul]{HttpClient}}
#' @param proxy List of arguments for a proxy connection, including one or more of:
#' url, port, username, password, and auth. See \code{\link[crul]{proxy}} for
#' help, which is used to construct the proxy connection.
#' @param errors (character) One of simple or complete. Simple gives http code and
#' error message on an error, while complete gives both http code and error message,
#' and stack trace, if available.
#' @param progress a function with logic for printing a progress
#' bar for an HTTP request, ultimately passed down to \pkg{curl}.
#' only supports \code{httr::progress()}
#'
#' @details Details:
#' @section Faceting:
#' Read more about faceting here: url{http://wiki.apache.org/solr/SimpleFacetParameters}
#'
#' @section Website vs. API behavior:
#' Don't be surprised if queries you perform in a scripting language, like using \code{rplos}
#' in R, give different results than when searching for articles on the PLOS website. I am
#' not sure what exact defaults they use on their website. There are a few things to consider.
#' You can tweak which types of articles are returned: Try using the \code{article_type}
#' filter in the \code{fq} parameter. For which journal to search, e.g., do
#' \code{'journal_key:PLoSONE'}. See \code{journalnamekey()} for journal
#' abbreviations.
#'
#' @section Phrase searching:
#' To search phrases, e.g., \strong{synthetic biology} as a single item, rather than
#' separate occurrences of \strong{synthetic} and \strong{biology}, simply put double
#' quotes around the phrase. For example, to search for cases of \strong{synthetic biology},
#' do \code{searchplos(q = '"synthetic biology"')}.
#'
#' You can modify phrase searches as well. For example,
#' \code{searchplos(q = '"synthetic biology" ~ 10')} asks for cases of
#' \strong{synthetic biology} within 10 words of each other. See examples.
#' 
#' @section Pagination:
#' The \code{searchplos} function and the many functions that are wrappers around 
#' \code{searchplos} all do paginatino internally for you. That is, if you request for 
#' example, 2000 results, the max you can get in any one request is 1000, so we'll do 
#' two requests for you. And so on for larger requests. 
#' 
#' You can always do your own paginatino by doing a lapply type call or a for loop 
#' to cycle through pages of results. 
