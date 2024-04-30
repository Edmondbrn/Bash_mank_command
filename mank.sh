#!/bin/bash
# Fonction qui affiche l'aide liée à la commande
help() {
    echo "usage: $cmd aide recherche par mots clés"
    echo
    echo "Commande qui décrit brièvement une autre commande."
    echo "Fonctionne en plaçant un ou plusieurs mot-clés en argument."
    echo "Si plusieurs arguments sont donnés la commande ressortira tous les match comprenant au moins un des mot-clés (voir -d pour le contraire)"
    echo
    echo "Argument:"
    echo "-h            Affiche l'aide de la commande"
    echo "-i            Affiche les commandes non prises en charges par mank"
    echo "-a            Ajouter un fichier de mank"
    echo "-d            Affiche les commandes contenant tous les mots clés spécifiés"
}

# Fonction pour lister les fichiers dans un répertoire spécifié
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

# Fonction pour ajouter un fichier de mank
ajouter_fichier_mank() {
    read -p "Nom du fichier de mank : " nom_fichier
    if [ "$nom_fichier" == "" ] || [ -e "./mank_utils/$nom_fichier" ]; then # test si nom vide ou fichier déjà existant
        zenity --error --title="Erreur nom du fichier" --text="Veuillez renseigner un nom de fichier non nul et n'existant pas déjà."
        exit
    fi
    while true; do # boucle pour gérer les entrées de la description
        read -p "Description : " description
        if [ "$description" == "" ]; then
            if zenity --question --text="Votre description est vide, voulez-vous continuer ?"; then # si on dit oui
                break
            fi
        else
            break # si l'entrée est correcte
        fi
    done
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

parcours_fichier(){
    DIR="./mank_utils" # creation du chemin vers le dossier contenant les fichiers descriptifs
    liste_fichier=$(Liste_Fichier $DIR) # recupère la sortie et l'applique à une variable
    check="0" # variable pour savoir si le mot a été trouvé ou non
    for element in $liste_fichier; do # parcours fichier dans le dossier
        tableau=()
        for cle in "$@"; do # parcours des mot cle si on en a plusieurs
            if grep -q -w "$cle" "$DIR/$element"; then # grep -q n'affiche rien et permet de faire une condition et -w permet de ne chercher que des mots entiers et pas des sous chaines
                tableau+=("$cle") # on ajoute le mot clé dans un tuple
            fi
        done;
        if [ ${#tableau[@]} != 0 ]; then # on teste si le tuple est vide, donc si on au moins 1 match
                echo ""$element" : $(head -n 1 "$DIR/$element") ("${tableau[@]}")." # message de sortie en cas de match
                check=1
        fi
    done;
    if [ "$check" == "0" ]; then # message d'erreur si on n'a rien trouvé
        echo "Erreur : mot-clé inconnu dans la base de données."
    fi
}

parcours_fichier_-d(){
    DIR="./mank_utils" # creation du chemin vers le dossier contenant les fichiers descriptifs
    liste_fichier=$(Liste_Fichier $DIR) # recupère la sortie et l'applique à une variable
    check="0" # variable pour savoir si le mot a été trouvé ou non
    nbr_mot=$#  # compte le nombre de mots donné (ne prend pas en compte l'argument -d)
    if [ "$nbr_mot" == 0 ]; then
        echo "Veuillez spécifier des mots-clés avec l'option -d s'il vous plait."
        exit
    fi
    for element in $liste_fichier; do # parcours fichier dans le dossier
        tableau=()
        for cle in "$@"; do # parcours des mot cle si on en a plusieurs
            if grep -q -w "$cle" "$DIR/$element"; then # grep -q n'affiche rien et permet de faire une condition et -w permet de ne chercher que des mots entiers et pas des sous chaines
                tableau+=("$cle") # on ajoute le mot clé dans un tuple
            fi
        done;
        if [ "$nbr_mot" == "${#tableau[@]}" ]; then # test si on a trouvé tous les mots clés dans la commande
            echo "Match parfait, "$element" : $(head -n 1 "$DIR/$element") ("${tableau[@]}")."
            check=1
        fi
    done;
    if [ "$check" == "0" ]; then # message d'erreur si on n'a rien trouvé
        echo "Erreur : aucun match parfait dans les données mank."
    fi
}

verif_argument(){
    for mot in "$@"; do
        if [[ "${mot:0:1}" == "-" ]]; then # test si un des mots clés commencent par un - (fait buguer grep)
            zenity --error --title="Erreur de saisie" --text="L'un des mots-clés coommence par -. \n                Veuillez le corriger."
            exit
        fi
    done
}

# Test des arguments donnés
if [ "$1" == "-h" ]; then # Est ce que l'utilisateur demande l'aide de la commande
    help
    exit
elif [ "$1" == "-i" ]; then # Si l'utilisateur souhaite connaitre les commandes non traitées
    commande_manquante
    exit
elif [ "$1" == "-a" ]; then
    ajouter_fichier_mank
    exit
elif [ "$1" == "-d" ]; then
    verif_argument "${@:2}"
    parcours_fichier_-d "${@:2}" # donne tous les arguments sauf le 1er (-d)
    exit
elif [ "$#" == 0 ]; then
    echo "Erreur : veuillez saisir un argument. Voici l'aide de la commande :"
    echo
    help
    exit # quitte le programme
else 
    verif_argument "$@"
    parcours_fichier $@
    exit
fi

