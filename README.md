# Modèle de thèse — FTI / Département TIM (Université de Genève)

Modèle LaTeX de **thèse de doctorat** pour la Faculté de traduction et
d'interprétation (FTI), Département de traitement informatique
multilingue (TIM), Université de Genève.

[![Open in Overleaf](https://img.shields.io/badge/Open%20in-Overleaf-47A141?logo=overleaf&logoColor=white)](https://www.overleaf.com/docs?snip_uri=https://github.com/drvenabili/tim-template/archive/refs/heads/main.zip)

> Le bouton **Open in Overleaf** importe le dépôt dans un nouveau projet.
> Pensez ensuite à régler le compilateur sur **XeLaTeX**
> (*Menu → Settings → Compiler*).


- **Moteur : XeLaTeX** (Unicode natif, `fontspec`, `polyglossia`).
- **Multilingue** : français (langue principale) + arabe, russe, chinois,
  japonais, grec pré-configurés, avec exemples.
- **Polices 100 % libres** (Noto). Aucune police propriétaire.
- **Bibliographie** : `biblatex` + `biber`, style auteur-date.
- **Identité visuelle** : couleurs de la charte graphique UNIGE, logo
  institutionnel, accent aux couleurs de la FTI.

## Compilation

Le document se compile avec **XeLaTeX** (surtout pas pdfLaTeX), suivi de
**biber** pour la bibliographie :

```bash
xelatex these
biber   these
xelatex these
xelatex these
```

Ou, si `latexmk` est installé (il lit le fichier `latexmkrc` fourni) :

```bash
latexmk these        # compile tout (XeLaTeX + biber)
latexmk -c           # nettoie les fichiers auxiliaires
```

### Sur Overleaf (recommandé)

1. Importez ce dépôt (ou téléversez les fichiers).
2. Dans *Menu → Settings*, réglez **Compiler : XeLaTeX**.
3. Compilez. Les polices Noto (latines, CJK, arabe) sont **déjà
   installées** sur Overleaf : rien d'autre à faire.

## Polices

Le corps du texte utilise **Noto Serif** (couvre le latin, le cyrillique
et le grec) ; les titres, **Noto Sans** (substitut libre de la police
institutionnelle *TheSans*, qui est propriétaire) ; le code, **Noto Sans
Mono**. Les écritures non latines utilisent :

| Écriture | Police |
|----------|--------|
| Arabe    | Noto Naskh Arabic |
| Chinois  | Noto Serif CJK SC |
| Japonais | Noto Serif CJK JP |
| Grec / Cyrillique | Noto Serif |

### Cas particulier : systèmes à « polices variables »

Certaines distributions Linux récentes (p. ex. **Fedora**) ne fournissent
les polices Noto que sous forme de **polices variables** (fichiers du
type `NotoSerif[wght].ttf`, `NotoSerifCJK-VF.ttc`). Or le générateur de
PDF de XeLaTeX (`xdvipdfmx`) **ne sait pas embarquer** une police
variable et échoue avec :

```
xdvipdfmx:fatal: Invalid font
```

**Ce problème n'existe pas sur Overleaf** ni sur la plupart des
installations TeX Live, où les versions statiques sont présentes.

Si vous rencontrez cette erreur en local, exécutez une fois :

```bash
bash scripts/get-fonts.sh
```

Ce script dépose des versions **statiques** des polices dans
`ressources/polices/` :

- copie les faces statiques de Noto Serif/Sans/Mono trouvées sur le
  système ;
- télécharge les OTF statiques de Noto Serif CJK (SC + JP) depuis le
  dépôt officiel *notofonts/noto-cjk* ;
- génère une instance statique de Noto Naskh Arabic (nécessite
  `fonttools` : `pip install fonttools`).

Le modèle détecte automatiquement ces fichiers (via `\IfFileExists`) et
les charge en priorité. Ces polices sont **ignorées par git**
(`.gitignore`) car volumineuses (~100 Mo pour le CJK) ; ne les
committez pas.

### Prérequis (installation locale, Fedora)

```bash
sudo dnf install texlive-scheme-medium texlive-polyglossia \
     texlive-biblatex biber texlive-koma-script texlive-microtype \
     google-noto-serif-fonts google-noto-sans-fonts \
     google-noto-naskh-arabic-fonts google-noto-serif-cjk-fonts
```

(`texlive-microtype` est facultatif : le modèle ne le charge que s'il est
présent.)

## Structure du projet

```
these.tex                 Document maître (métadonnées + \input)
config/
  preambule.tex           Classe scrbook, géométrie, paquets, hyperref
  polices.tex             fontspec : latin, CJK, arabe (+ repli statique)
  langues.tex             polyglossia : français + langues secondaires
  style-fti.tex           Couleurs charte UNIGE, en-têtes, titres
  biblio.tex              biblatex + biber (auteur-date)
couverture/
  page-titre.tex          Page de titre au style FTI
corps/
  00-remerciements.tex
  00-resume.tex           Résumé (fr) + abstract (en)
  01-introduction.tex
  02-exemples-multilingues.tex   Démonstration multi-écritures
  99-conclusion.tex
annexes/
  A-annexe.tex
biblio/
  references.bib          Références (dont travaux du Département TIM)
ressources/
  logo-unige.pdf          Logo institutionnel (vectoriel)
  logo-unige.svg          Source SVG du logo
  polices/                Polices statiques locales (non versionnées)
scripts/
  get-fonts.sh            Récupère des polices statiques (voir ci-dessus)
```

## Personnalisation

- **Métadonnées** (titre, auteur, jury, date…) : en haut de `these.tex`.
- **Couleur d'accent** : dans `config/style-fti.tex`, la macro `accent`
  vaut par défaut la couleur de la FTI (`ftiOrange`, Pantone 152C).
  Remplacez-la par `unigeRouge` (Pantone 214C) pour un rendu
  institutionnel plus neutre.
- **Écritures** : les commandes `\ar{}`, `\ru{}`, `\zh{}`, `\ja{}`,
  `\gr{}` insèrent un fragment court ; pour un passage long, utilisez les
  environnements `\begin{Arabic}…\end{Arabic}`, `\begin{russian}…`, etc.
  (voir `corps/02-exemples-multilingues.tex`).

  > Note : l'environnement arabe s'écrit avec une **majuscule**
  > (`Arabic`) pour éviter un conflit avec la commande `\arabic` de LaTeX.

## Écritures dans la bibliographie

Pour qu'un titre ou un auteur en écriture arabe ou chinoise s'affiche
correctement dans la bibliographie (qui utilise la police latine par
défaut), encapsulez le champ concerné avec `\ar{}` ou `\zh{}` dans le
fichier `.bib`. Voir les entrées `aljahiz` et `luxun1932` de
`biblio/references.bib` comme modèles.

## Couleurs de la charte UNIGE

D'après la charte graphique du Service de communication
(<https://www.unige.ch/communication/publier/charte/couleurs>) :

| Élément | Pantone | Hex |
|---------|---------|-----|
| Rouge institutionnel UNIGE | 214C | `#CF0063` |
| Gris du sceau | — | `#A3A3A3` |
| Faculté de traduction et d'interprétation (FTI) | 152C | `#FF5C00` |

## Logo

`ressources/logo-unige.pdf` (converti depuis le SVG de Wikimedia Commons,
« File:Uni GE logo.svg »). Pour une conformité stricte à la charte,
remplacez-le par la version officielle fournie par le Service de
communication de l'UNIGE.
