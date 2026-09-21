# Modèle de thèse — FTI / Département TIM (Université de Genève)

Modèle LaTeX de **thèse de doctorat** pour la Faculté de traduction et
d'interprétation (FTI), Département de traitement informatique
multilingue (TIM), Université de Genève.

[![Open in Overleaf](https://img.shields.io/badge/Open%20in-Overleaf-47A141?logo=overleaf&logoColor=white)](https://www.overleaf.com/docs?engine=xelatex&snip_uri=https://github.com/drvenabili/tim-template/releases/latest/download/These-UNIGE-FTI.zip)

> Le bouton **Open in Overleaf** importe le modèle dans un nouveau projet
> nommé **« These-UNIGE-FTI »** et règle d'emblée le compilateur sur
> **XeLaTeX** (paramètre `engine=xelatex`). Si jamais Overleaf revenait à
> pdfLaTeX, réglez-le manuellement : *Menu → Settings → Compiler →
> XeLaTeX*.
>
> Le bouton pointe vers l'archive `These-UNIGE-FTI.zip` de la **dernière
> release** GitHub. Il ne fonctionnera donc qu'après la publication d'une
> première release — voir la section
> [« Publier une nouvelle version »](#publier-une-nouvelle-version-release-github)
> (un clic depuis l'onglet Actions). Tant qu'aucune release n'existe,
> utilisez l'archive de la branche :
> `…/docs?engine=xelatex&snip_uri=https://github.com/drvenabili/tim-template/archive/refs/heads/main.zip`
> (le projet s'appellera alors « main » ; renommez-le en un clic dans
> Overleaf via *Menu → Rename*).


- **Moteur : XeLaTeX** (Unicode natif, `fontspec`, `polyglossia`).
- **Multilingue** : français (langue principale) + arabe, russe, chinois,
  japonais, grec pré-configurés, avec exemples.
- **Polices 100 % libres** (Noto). Aucune police propriétaire.
- **Bibliographie** : `biblatex` + `biber`, style **APA 7** (auteur-date).
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
| Tigrinya (guèze) | Noto Serif Ethiopic |
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
     google-noto-naskh-arabic-fonts google-noto-serif-cjk-fonts \
     google-noto-serif-ethiopic-fonts google-noto-sans-ethiopic-fonts
```

> Note : installez bien les paquets de polices **sans** le suffixe `-vf-`
> (versions statiques). Les versions variables (`…-vf-fonts`) ne peuvent
> pas être embarquées par XeLaTeX (`xdvipdfmx: Invalid font`). C'est
> notamment le cas pour l'éthiopien (tigrinya) :
> `google-noto-serif-ethiopic-fonts`, pas `…-ethiopic-vf-fonts`.

(`texlive-microtype` est facultatif : le modèle ne le charge que s'il est
présent.)

## Publier une nouvelle version (release GitHub)

Le bouton **Open in Overleaf** pointe vers l'archive `These-UNIGE-FTI.zip`
de la **dernière release**. Pour créer/mettre à jour cette archive en un
clic :

1. Onglet **Actions** du dépôt GitHub.
2. Workflow **« Release Overleaf zip »** → bouton **« Run workflow »**.
3. Saisir le **tag** (ex. `v1.1`), éventuellement un titre et des notes,
   puis **Run workflow**.

Le workflow (`.github/workflows/release-zip.yml`) construit l'archive
(en excluant `.git`, les polices lourdes et les artefacts LaTeX), crée le
tag et la release, puis y attache `These-UNIGE-FTI.zip`. Le bouton
*Open in Overleaf* utilise alors automatiquement cette nouvelle version.

> Le workflow échoue volontairement si le tag existe déjà (pour ne pas
> écraser une release). Choisissez un nouveau numéro de version.

## Structure du projet

```
these.tex                 Document maître (métadonnées + \input)
config/
  preambule.tex           Classe scrbook, géométrie, paquets, hyperref
  polices.tex             fontspec : latin, CJK, arabe (+ repli statique)
  langues.tex             polyglossia : français + langues secondaires
  style-fti.tex           Couleurs charte UNIGE, en-têtes, titres
  biblio.tex              biblatex + biber (APA 7, repli auteur-date)
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

## Style bibliographique

La FTI **n'impose pas un style unique**. L'*Aide-mémoire à l'intention
des étudiants préparant un mémoire de maîtrise en traduction ou en
technologies de la traduction et de la communication* (MA traduction /
MATECH) précise que « les citations et références suivent les consignes
de votre unité ou de votre jury » et que la présentation formelle est
fixée « par votre directeur ou directrice de mémoire ». Le format
attendu est de type **auteur-date**.

Ce modèle utilise par défaut **APA 7** (via `biblatex-apa`), qui est la
norme de référence à l'échelle de l'UNIGE et convient bien au Département
TIM. Le style se règle dans `config/biblio.tex` :

- **APA 7** (défaut) : nécessite `biblatex-apa`, présent sur Overleaf et
  dans une installation TeX Live complète.
- **Repli automatique** : si `biblatex-apa` est absent, le modèle bascule
  sur le style natif `authoryear` (auteur-date lui aussi) ; le document
  compile alors partout.
- Pour **forcer** `authoryear` (p. ex. en cas d'erreur
  `usenarrator undefined` due à un `biblatex` et un `biblatex-apa`
  désynchronisés sur certaines distributions Linux), commentez la ligne
  `\thesisapatrue` dans `config/biblio.tex`.

Vérifiez auprès de votre directeur/directrice de mémoire le style
réellement attendu et adaptez `config/biblio.tex` en conséquence.

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

  > **Arabe (droite à gauche).** L'arabe est géré par `polyglossia`
  > (paquet `bidi`), ce qui assure un **véritable rendu RTL** : un gros
  > paragraphe arabe est justifié et aligné à droite, avec un ordre des
  > lignes et une césure corrects. Utilisez `\ar{…}` pour un fragment
  > court et l'environnement `\begin{Arabic}…\end{Arabic}` (avec une
  > **majuscule**, pour éviter le conflit avec la commande `\arabic`) pour
  > un paragraphe entier.
  >
  > **Compatibilité TeX Live 2026 / Overleaf.** Le noyau LaTeX 2026 a
  > retiré la « fake math » autour des tableaux ; `bidi` provoque alors une
  > erreur `\UseMathForPositioningText` dès qu'un tableau contient (ou
  > côtoie) de l'arabe. Le modèle intègre le correctif recommandé (un shim
  > `\providecommand\UseMathForPositioningText{\m@th}` dans
  > `config/preambule.tex`) : les tableaux et l'arabe fonctionnent
  > ensemble, sur Overleaf comme en local. Réf. :
  > <https://www.overleaf.com/blog/tex-live-2026-is-now-available>

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
