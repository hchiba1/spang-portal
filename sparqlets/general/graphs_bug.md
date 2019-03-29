# SELECT DISTINCT ?graph, instead of GROUP BY ?graph, returns less results (Virtuoso 7.1.0)

## Parameters


## Endpoint
http://dbpedia.org/sparql

## `result`

```sparql
SELECT DISTINCT ?g
WHERE {
    GRAPH ?g {
	?s ?p ?o
    }
}


```
