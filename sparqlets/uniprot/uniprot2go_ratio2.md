# 

## Parameters


## Endpoint
http://sparql.uniprot.org

## `result`

```sparql
PREFIX xsd: <http://www.w3.org/2001/XMLSchema#>
PREFIX up: <http://purl.uniprot.org/core/>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX tax: <http://purl.uniprot.org/taxonomy/>

SELECT ?go ?go_label ?count ?count_all ((xsd:decimal(?count) / ?count_all) AS ?ratio)
WHERE {
    {
	SELECT ?go ?go_label (COUNT(?uniprot) AS ?count)
	WHERE {
	    {
		SELECT DISTINCT ?uniprot ?go ?go_label
		WHERE {
		    ?uniprot up:classifiedWith ?go .
		    ?go up:database <http://purl.uniprot.org/database/go> ;
                    rdfs:label ?go_label .
		    VALUES (?uniprot) { $STDIN }
		}
	    }
	}
    }
    {
	SELECT ?go (COUNT(?uniprot_all) AS ?count_all)
	WHERE {
	    {
		SELECT DISTINCT ?uniprot_all ?go
		WHERE {
		    ?uniprot_all up:classifiedWith ?go ;
		    up:organism tax:9606 .
		}
	    }
	}
    }
}
ORDER BY DESC(?ratio)


```
