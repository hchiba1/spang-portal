# List of GO IDs

## Parameters


## Endpoint
http://sparql.uniprot.org

## `result`

```sparql
PREFIX up: <http://purl.uniprot.org/core/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?go ?go_label
WHERE {
    ?go up:database <http://purl.uniprot.org/database/go> ;
        rdfs:label ?go_label .
}


```
