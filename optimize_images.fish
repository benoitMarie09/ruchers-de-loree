#!/usr/bin/env fish

# Script d'optimisation d'images pour gallery web
# Crée des versions optimisées et des thumbnails

set -l input_dir images
set -l output_dir images/optimized
set -l thumb_dir images/thumbnails

# Paramètres d'optimisation
set -l web_quality 85
set -l web_width 1200
set -l thumb_size 300

echo "🖼️  Optimisation des images pour la gallery..."

# Crée les dossiers de sortie
mkdir -p $output_dir $thumb_dir

# Vérifie que ImageMagick est installé
if not command -v convert >/dev/null
    echo "❌ ImageMagick n'est pas installé"
    echo "   Installation: sudo apt install imagemagick"
    exit 1
end

# Traite chaque image dans le dossier images
for image in $input_dir/*.{jpg,jpeg,png,JPG,JPEG,PNG}
    if test -f $image
        set -l basename (basename $image)
        set -l name (string split -r -m1 . $basename)[1]
        set -l ext (string split -r -m1 . $basename)[2]

        # Définit l'extension de sortie (toujours jpg pour web)
        set -l web_name "$name.jpg"
        set -l thumb_name "$name-thumb.jpg"

        echo "📷 Traitement de $basename..."

        # Version web optimisée
        convert "$image" \
            -resize "$web_width"x"$web_width>" \
            -quality $web_quality \
            -strip \
            -interlace Plane \
            "$output_dir/$web_name"

        # Thumbnail carré
        convert "$image" \
            -resize "$thumb_size"x"$thumb_size^" \
            -gravity center \
            -crop "$thumb_size"x"$thumb_size+0+0" \
            -quality 80 \
            -strip \
            "$thumb_dir/$thumb_name"

        # Affiche les tailles
        set -l original_size (du -h "$image" | cut -f1)
        set -l web_size (du -h "$output_dir/$web_name" | cut -f1)
        set -l thumb_size_kb (du -h "$thumb_dir/$thumb_name" | cut -f1)

        echo "  ✅ Original: $original_size → Web: $web_size → Thumb: $thumb_size_kb"
    end
end

echo ""
echo "🎉 Optimisation terminée !"
echo "   📁 Images web: $output_dir/"
echo "   🖼️  Thumbnails: $thumb_dir/"
echo ""
echo "💡 Utilisation dans ton HTML :"
echo '   <img src="images/thumbnails/photo-thumb.jpg" onclick="showLarge('"'"'images/optimized/photo.jpg'"'"')">'
