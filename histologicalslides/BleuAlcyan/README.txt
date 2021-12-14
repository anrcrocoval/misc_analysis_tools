** Purpose**
Quantify the repartition of collagen staining , and nuclei?
On mitral valves KI and WT, 
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
0) set the correct staining (initialised by selected ROI containing only H, and then only BA, the, refined by preprocessing, estimate stain vectors).
Created a script (BAstainScript.groovy) and then apply to all image in project. 
1) dessiner une roi autour d'un des feuillet de la valve
2) Segmenter le bleu d'alcian? et récupérer l'intensité par pixel?

comme le bleu alcyan est un marquage "diffus", i.e n'esp pas associé à des objets spécifiques dans l'image:

- soit mesurer l'intensité du bleu alcyan (après déconvolution couleur) dans les zones normalisées définies, peut etre en prenant plus de zones (par exemple 5x5)

- soit de mesurer le ratio de recouvrement de ces zones , en ayant donc mis un seuil sur le bleu alcyan,

résultats sur 4 valves KI et 4 valves WT 


