# 

## Parameters
* `arg1`
  * default: TIGR

## Endpoint


## `result`

```sparql
PREFIX mbgd: <http://purl.jp/bio/11/mbgd#>
PREFIX dct: <http://purl.org/dc/terms/>
PREFIX orthology: <http://purl.org/net/orth#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

#stdin <http://mbgd.genome.ad.jp/rdf/resource/gene/puf:UFO1_RS15575>
SELECT DISTINCT ?gene_id ?begin ?end ?motif_name ?e_value ?motif_begin ?motif_end ?motif_length ?motif_descr ?gene_length ?gene_name ?gene_descr
WHERE {
    VALUES (?gene) { (<http://mbgd.genome.ad.jp/rdf/resource/gene/puf:UFO1_RS15575>) }
    ?motif_hit mbgd:motifType "{{arg1}}";
        mbgd:gene ?gene ;
	mbgd:begin ?begin ;
	mbgd:end ?end ;
	mbgd:motifName ?motif_name ;
	mbgd:eValue ?e_value ;
	mbgd:motifBegin ?motif_begin ;
	mbgd:motifEnd ?motif_end ;
	mbgd:motif ?motif .
    ?motif mbgd:motifLength ?motif_length ;
        dct:description ?motif_descr .
    ?gene a orthology:Gene ;
        dct:identifier ?gene_id ;
	rdfs:label ?gene_name ;
	mbgd:aaLength ?gene_length ;
	dct:description ?gene_descr .
}
ORDER BY ?gene_id ?begin ?end


```
