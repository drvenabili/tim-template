#!/usr/bin/env bash
# =====================================================================
#  scripts/get-fonts.sh
#  Dépose des polices STATIQUES dans ressources/polices/ pour les
#  systèmes qui ne fournissent que des polices VARIABLES (p. ex. Fedora),
#  ce qui fait échouer XeLaTeX avec « xdvipdfmx:fatal: Invalid font ».
#
#  INUTILE sur Overleaf et sur la plupart des installations TeX Live :
#  les versions statiques y sont déjà présentes et le modèle les charge
#  par leur nom. N'exécutez ce script que si la compilation échoue avec
#  une erreur de police CJK ou arabe.
#
#  Ce que fait le script :
#    - télécharge les OTF STATIQUES de Noto Serif CJK (SC + JP) ;
#    - génère une instance STATIQUE de Noto Naskh Arabic à partir de la
#      police variable du système, si fonttools est disponible.
#
#  Usage :  bash scripts/get-fonts.sh
# =====================================================================
set -euo pipefail

DEST="$(cd "$(dirname "$0")/.." && pwd)/ressources/polices"
mkdir -p "$DEST"

BASE="https://github.com/notofonts/noto-cjk/raw/main/Serif/OTF"

echo ">> Téléchargement des OTF statiques Noto Serif CJK (SC + JP)…"
declare -A FILES=(
  ["$BASE/SimplifiedChinese/NotoSerifCJKsc-Regular.otf"]="NotoSerifCJKSC-Regular.otf"
  ["$BASE/SimplifiedChinese/NotoSerifCJKsc-Bold.otf"]="NotoSerifCJKSC-Bold.otf"
  ["$BASE/Japanese/NotoSerifCJKjp-Regular.otf"]="NotoSerifCJKJP-Regular.otf"
  ["$BASE/Japanese/NotoSerifCJKjp-Bold.otf"]="NotoSerifCJKJP-Bold.otf"
)
for url in "${!FILES[@]}"; do
  out="$DEST/${FILES[$url]}"
  echo "   - ${FILES[$url]}"
  curl -fsSL -o "$out" "$url"
done

echo ">> Polices latines (Noto Serif/Sans/Mono) : copie des faces STATIQUES…"
#  Sur les systèmes où « Noto Serif » existe en version VARIABLE
#  (google-noto-vf/NotoSerif[wght].ttf) À CÔTÉ des faces statiques, le
#  chargement par nom peut sélectionner la version variable et faire
#  échouer xdvipdfmx. On copie donc les faces statiques si on les trouve.
copy_static() {
  local base="$1"; shift
  local srcdir=""
  for d in /usr/share/fonts/google-noto /usr/share/fonts/*noto* \
           "$HOME/.fonts" "$HOME/.local/share/fonts"; do
    [ -f "$d/${base}-Regular.ttf" ] && srcdir="$d" && break
  done
  if [ -z "$srcdir" ]; then
    echo "   - $base : faces statiques introuvables (ignoré)."
    return
  fi
  for style in "$@"; do
    [ -f "$srcdir/${base}-${style}.ttf" ] && \
      cp -f "$srcdir/${base}-${style}.ttf" "$DEST/${base}-${style}.ttf"
  done
  echo "   - $base : faces copiées depuis $srcdir."
}
copy_static NotoSerif    Regular Bold Italic BoldItalic
copy_static NotoSans     Regular Bold Italic BoldItalic
copy_static NotoSansMono Regular Bold

echo ">> Police arabe : génération d'une instance statique (si nécessaire)…"
ARABIC_VF="$(fc-match -f '%{file}' 'Noto Naskh Arabic' 2>/dev/null || true)"
if command -v fonttools >/dev/null 2>&1 && [ -n "$ARABIC_VF" ] && [[ "$ARABIC_VF" == *"["* ]]; then
  fonttools varLib.instancer "$ARABIC_VF" wght=400 \
    -o "$DEST/NotoNaskhArabic-Regular.ttf"
  fonttools varLib.instancer "$ARABIC_VF" wght=700 \
    -o "$DEST/NotoNaskhArabic-Bold.ttf"
  echo "   - instance statique Noto Naskh Arabic générée."
else
  echo "   - non requis (police déjà statique) ou fonttools absent."
  echo "     Sinon : pip install fonttools, puis relancez ce script."
fi

echo ">> Terminé. Les polices sont dans : $DEST"
echo "   Elles sont ignorées par git (.gitignore) ; ne les committez pas."
