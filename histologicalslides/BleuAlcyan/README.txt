** Purpose**
Quantify the repartition of collagen staining , and nuclei?
On mitral valves KI and WT, 
with geodesic distances.

** Load image in project QUPATH (version used 0.3.1)
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
2) Segmenter le bleu d'alcian? (create pixel classifier threshold 0.2), resolution Very high (cf scripts BApos): verifier que seuillage ok
3) Exporter le color scheme original pour pouvoir segmenter la valve sous Fiji (Distance quantification)
-> lancer ensuite Createdistance, createquantile, et quantif ratio
Rajouter les noms de fichiers et trcuspid/mitral

comme le bleu alcyan est un marquage "diffus", i.e n'esp pas associé à des objets spécifiques dans l'image:


mesurer le ratio de recouvrement de ces zones , en ayant donc mis un seuil sur le bleu alcyan,

résultats sur 4 valves KI et 4 valves WT 

La coloration au bleu alcian permet de colorer les mucosités acides et les mucines acétiques.
Des quantités excessives de mucosités acides non sulfatées sont observées dans les mésothéliomes. Ces mucosités sont présentent en quantités normales dans les parois des vaisseaux sanguins mais augmentent dans les lésions précoces d'athérosclérose.
La coloration au bleu Alcian repose sur un groupe de colorants basiques polyvalents qui sont solubles dans l'eau. La couleur bleue est due à la présente de cuivre.
Le pH de la solution de coloration au bleu Alcian est très important et a un effet direct sur la catégorie de mucines révélées par cette méthode. Le pH de la solution de coloration au bleu Alcian peut être compris entre 0.4 et 2.5.
Si l e pH de la solution est de 1.0, la solution va colorer les mucines acides sulfatées. Ces mucines se retrouvent principalement dans le cartilage, les cellules caliciformes du gros intestin et les.glandes séreuses bronchiques
Si la solution de coloration au bleu Alcian a un pH de 2.5, ce sont les mucines carboxylées dans les tissus conjonctifs et le cartilage qui seront colorées.

***LLocalisation de l'elargissement sur coupe histo***

Launch CreateDistanceMaps (with the looging of Atrial/ventricular length)
MorpholibJ should be installed https://imagej.net/plugins/morpholibj  IJPB-plugins site to your list of update sites
cite Legland, D., Arganda-Carreras, I., & Andrey, P. (2016). MorphoLibJ: integrated library and plugins for mathematical morphology with ImageJ. Bioinformatics, btw413. doi:10.1093/bioinformatics/btw413

Script R pour plotter
