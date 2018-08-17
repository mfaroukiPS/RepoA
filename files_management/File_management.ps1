import-module .\Add_line.psm1 -force
import-module .\delete_line.psm1 -force
import-module .\Replace_line.psm1 -force


#Exemple

# Ajout d'une variable:

	#Ajouter_ligne -Fichier_a_Inclure "Navitia*.ini" -Fichier_a_EXclure "Navitia_Updater.ini" -NVariable_to_add 'UseLinkTime=1' -Nvariable_to_check '[LOG]'

	#Ajouter_ligne -Fichier_a_Inclure "Navitia*.ini" -Fichier_a_EXclure "Navitia_Updater.ini" -NVariable_to_add 'UseLinkTime=1' -Nvariable_to_check '[LOG]'

	# Pour Ajouter plusieurs inclusions ou exclusions passer cette chaine de caractére au variable -Fichier_a_EXclure ou -NVariable_to_add    "Navitia*.ini","gwnavitia*.ini"

#supprimer la ligne ajouté:

	#Supprimer_ligne -Fichier_a_Inclure "Navitia*.ini" -Fichier_a_EXclure "Navitia_Updater.ini" -NVariable_to_delete 'UseLinkTime=1'

#modifier la ligne ajouté: 
	
	#modifier_ligne -Fichier_a_Inclure "Navitia*.ini"  -Fichier_a_EXclure "Navitia_Updater.ini"  -NVariable_a_replacer 'UseLinkTime=1' -NVariable_de_remplacement 'UseLinkTime=0'