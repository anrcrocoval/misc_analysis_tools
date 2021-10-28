** Purpose**
Quantify the repartition of collagen staining , and nuclei?
On miral valves KI and WT, 
with geodesic distances.

** Load image in project QUPATH (version used 0.3.0)
*Mix of czi and ndpi *
In version 0.3.0 open natively.
Otherwise follow instruction here:
https://github.com/qupath/qupath/wiki/Supported-image-formats#zeiss-czi

* Add medadata *
Type: KI or WT
Age: 3W or 6W

** Workflow:
0) set the correct staining (initialised by selected ROI containing only H, and then only BA, the, refined by pre^prosinng, estimate stain vectors).
Creta ea script (BAstainScript.groovy) and then apply to all image in project. 
1) dessiner une roi autour d'un des feuillet de la valve
2) Segmenter le bleu d'alcian? et récupérer l'intensité par pixel?




