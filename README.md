
MANK (Rappel de commande par mots clés)


## Définition des fonctions :
1. **`help()`** : Cette fonction affiche l'aide liée à la commande `mank.sh`, expliquant son utilisation et ses options disponibles.
   
2. **`Liste_Fichier()`** : Cette fonction liste les fichiers dans un répertoire spécifié. Elle est utilisée pour lister les fichiers de mank dans le dossier `mank_utils`.

3. **`commande_manquante()`** : Cette fonction affiche les commandes non prises en charge par `mank.sh`, en comparant les commandes existantes avec celles pour lesquelles aucun fichier de mank n'a été créé.

4. **`ajouter_fichier_mank()`** : Cette fonction permet à l'utilisateur d'ajouter un fichier de mank. Elle lui demande de saisir le nom du fichier, une description, puis les mots-clés un par un, chaque mot-clé étant enregistré sur une ligne distincte dans le fichier de mank.

### Test des arguments donnés :
Le script vérifie les arguments passés lors de son exécution :
   - Si l'option `-h` est utilisée, il affiche l'aide en appelant la fonction `help()`.
   - Si l'option `-i` est utilisée, il affiche les commandes non prises en charge en appelant la fonction `commande_manquante()`.
   - Si l'option `-a` est utilisée, il permet à l'utilisateur d'ajouter un fichier de mank en appelant la fonction `ajouter_fichier_mank()`.
   - Si aucun argument n'est passé, il affiche un message d'erreur demandant à l'utilisateur de saisir un argument et affiche ensuite l'aide en appelant la fonction `help()`.

## Recherche de mots-clés :
1. Si l'utilisateur spécifie des mots-clés en argument lors de l'exécution de `mank.sh`, le script parcourt tous les fichiers de mank dans le dossier `mank_utils`.
2. Pour chaque fichier de mank, il recherche les mots-clés spécifiés.
3. Si un mot-clé correspond à un fichier de mank, le script affiche le nom du fichier et sa description.

En résumé, le script `mank.sh` permet à l'utilisateur d'ajouter des descriptions de commandes avec des mots-clés associés dans des fichiers de mank, de rechercher ces descriptions en fonction des mots-clés spécifiés, et de voir les commandes non prises en charge.

