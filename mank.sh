#!bin/bash -
help(){ # Fonction qui affiche l'aide liée à la commande
    echo "usage: $cmd aide recherche par mots clés"
    echo
    echo "Commande qui décrit brièvement une autre commande."
    echo "Fonctionne en plaçant un mot clé en argument."
    echo
    echo "Argument:"
    echo "-h            Affiche l'aide de la commande"
    echo "-i            Affiche les commandes non prises en charges par mank"
    echo "Votre mot-clé sans espace"
}

Liste_Fichier() {
    liste_fichier=$(ls "$1") # Stocke la liste des fichiers du sous-dossier mank_utils dans la variable liste_fichier
    echo "$liste_fichier" # Affiche la liste des fichiers
}

commande_manquante(){ # fonction qui affiche les commandes non prises en charge par mank
    com_traitee=$(Liste_Fichier "./mank_utils") # recéupère les fichiers traités
    com_gen=$(ls "/usr/bin") # récupère les non traités
    liste_com_nntraitee=$(diff -qr ./mank_utils /usr/bin | sed -e "s/.*: //" | grep -v "Les fichiers") # trouve la différence entre les deux (/usr/bin en référence) et on enlève le message pour ne garder que le nom de la commande et on enlève les lignes ou diff indique les fichiers ont le même nom mais pas le même contenu (grep -v)
    echo "Les commandes non prises en compte par mank sont:"
    echo "$liste_com_nntraitee" | pr -8 -t -a # formate la sortie

}

# Test des arguments donnés
if [ "$1" == "-h" ]; then # Est ce que l'utilisateur demande l'aide de la commande
    help
    exit
elif [ "$1" == "-i" ]; then # Si l'utilisateur souhaite connaitre les commandes non traitées
    commande_manquante
    exit
elif [ "$1" == "" ]; then
    echo "Erreur : veuillez saisir un argument. Voici l'aide de la commande"
    echo
    help
    exit # quitte le programme
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