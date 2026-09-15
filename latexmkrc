# latexmkrc — force XeLaTeX + biber pour ce modèle.
#
# Utilisation :  latexmk these
#          nettoyage :  latexmk -c   (artefacts)   /   latexmk -C  (+ PDF)
#
# $pdf_mode = 5 -> XeLaTeX (xelatex -> xdv -> pdf)
$pdf_mode = 5;
$xelatex  = 'xelatex -interaction=nonstopmode -halt-on-error -synctex=1 %O %S';

# biber pour la bibliographie (biblatex backend=biber).
$biber = 'biber %O %S';

# Fichiers à supprimer lors du nettoyage.
$clean_ext = 'bbl run.xml xdv synctex.gz';
