# Get paralogs of a specific protein

## Parameters
* `arg1`
  * default: ENSG00000244734

## Endpoint
https://sparql.omabrowser.org/sparql

## `result`

```sparql
PREFIX sio: <http://semanticscience.org/resource/>
PREFIX ens: <http://rdf.ebi.ac.uk/resource/ensembl/>
PREFIX oo: <http://purl.org/net/orth#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

PREFIX lscr: <http://purl.org/lscr#>
PREFIX ens: <http://rdf.ebi.ac.uk/resource/ensembl/>
SELECT ?paralog_protein ?OMA_link 
WHERE {
    ?cluster a oo:ParalogsCluster ;
             oo:hasHomologousMember ?node1 ;
             oo:hasHomologousMember ?node2 . 
    ?node1 oo:hasHomologousMember* ?query_protein .
    ?node2 oo:hasHomologousMember* ?paralog_protein .
    FILTER(?node1 != ?node2) 
    ?query_protein sio:SIO_010079/lscr:xrefEnsemblGene ens:{{arg1}} .
    ?paralog_protein rdfs:seeAlso ?OMA_link . 
}


```
