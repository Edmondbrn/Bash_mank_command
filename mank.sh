#!/bin/bash
# Fonction qui affiche l'aide liée à la commande
help() {
    echo "usage: $cmd aide recherche par mots clés"
    echo
    echo "Commande qui décrit brièvement une autre commande."
    echo "Fonctionne en plaçant un mot clé en argument."
    echo
    echo "Argument:"
    echo "-h            Affiche l'aide de la commande"
    echo "-i            Affiche les commandes non prises en charges par mank"
    echo "-a            Ajouter un fichier de mank"
    echo "Votre mot-clé sans espace"
}

# Fonction pour lister les fichiers dans un répertoire spécifié
Liste_Fichier() {
    local dir="$1"
    local liste_fichier=$(ls "$dir")
    echo "$liste_fichier"
}

# Fonction pour afficher les commandes non prises en charge par mank
commande_manquante() {
    local com_traitee=$(Liste_Fichier "./mank_utils")
    local com_gen=$(ls "/usr/bin")
    local liste_com_nntraitee=$(diff -qr ./mank_utils /usr/bin | sed -e "s/.*: //" | grep -v "Les fichiers")
    echo "Les commandes non prises en compte par mank sont:"
    echo "$liste_com_nntraitee" | pr -8 -t -a
}

# Fonction pour ajouter un fichier de mank
ajouter_fichier_mank() {
    read -p "Nom du fichier de mank : " nom_fichier
    read -p "Description : " description

    echo "$description" > "./mank_utils/$nom_fichier"

    echo "Mots clés (tapez 'fin' pour terminer) : "
    while true; do
        read mot_cle
        if [ "$mot_cle" == "fin" ]; then
            break
        fi
        echo "$mot_cle" >> "./mank_utils/$nom_fichier"
    done
}

# Test des arguments donnés
if [ "$1" == "-h" ]; then
    help
    exit
elif [ "$1" == "-i" ]; then
    commande_manquante
    exit
elif [ "$1" == "-a" ]; then
    ajouter_fichier_mank
    exit
elif [ "$1" == "" ]; then
    echo "Erreur : veuillez saisir un argument. Voici l'aide de la commande"
    echo
    help
    exit
fi



DIR="$(dirname "$0")/mank_utils" # creation du chemin vers le dossier contenant les fichiers descriptifs
liste_fichier=$(Liste_Fichier $DIR) # recupère la sortie et l'applique à une variable

check="0" # variable pour savoir si le mot a été trouvé ou non
for element in $liste_fichier; # parcours fichier dans le dossier
    do
        if grep -q "$1" "$DIR/$element"; then # grep -q n'affiche rien et permet de faire une condition
            echo ""$element" : $(head -n 1 "$DIR/$element")" # message de sortie en cas de match
            check=1
        fi
    done;
if [ "$check" == "0" ]; then # message d'erreur si on n'a rien trouvéa
    echo "Erreur : mot clé incconu dans la base de données"
fi
