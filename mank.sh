#!bin/bash -
help(){ # Fonction qui affiche l'aide liée à la commande
    echo "usage: $cmd aide recherche par mots clés"
    echo
    echo "Commande qui décrit brièvement une autre commande."
    echo "Fonctionne en plaçant un ou plusieurs mot-clés en argument."
    echo "Si plusieurs arguments sont donnés la commande ressortira tous les match comprenant au moins un des mot-clés (voir -d pour le contraire)"
    echo
    echo "Argument:"
    echo "-h            Affiche l'aide de la commande"
    echo "-i            Affiche les commandes non prises en charges par mank"
    echo "-a            Permet d'implémenter une nouvelle commande dans le registre mank"
    echo "-d            Permet de sortir les commandes comprenant plusieurs mot-clés s'ils sont spécifiés"
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

parcours_fichier(){
    DIR="./mank_utils" # creation du chemin vers le dossier contenant les fichiers descriptifs
    liste_fichier=$(Liste_Fichier $DIR) # recupère la sortie et l'applique à une variable

    check="0" # variable pour savoir si le mot a été trouvé ou non
    for element in $liste_fichier; do # parcours fichier dans le dossier
            for cle in "$@"; do # parcours des mot cle si on en a plusieurs
                if grep -q -w "$cle" "$DIR/$element"; then # grep -q n'affiche rien et permet de faire une condition
                    echo ""$element" : $(head -n 1 "$DIR/$element") ("$cle")" # message de sortie en cas de match
                    check=1
                    break
                fi
            done;
        done;
    if [ "$check" == "0" ]; then # message d'erreur si on n'a rien trouvéa
        echo "Erreur : mot clé inconnu dans la base de données"
    fi
}


# Test des arguments donnés
if [ "$1" == "-h" ]; then # Est ce que l'utilisateur demande l'aide de la commande
    help
    exit
elif [ "$1" == "-i" ]; then # Si l'utilisateur souhaite connaitre les commandes non traitées
    commande_manquante
    exit
elif [ "$1" == "-a" ]; then
    echo "Pas encore fait" # Ca serait bien d'avoir une petite fenetre pour que ce soit un peu plus fun à remplir
elif [ "$#" == 0 ]; then
    echo "Erreur : veuillez saisir un argument. Voici l'aide de la commande :"
    echo
    help
    exit # quitte le programme
else 
    parcours_fichier $@
    exit
fi