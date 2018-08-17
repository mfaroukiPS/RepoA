#script qui permet de rechercher une chaine dans les fichiers d'une arborescence et d'ajouter une ligne avant  
import-module .\WriteLog.psm1 -force
#========= fonction pour retourner le nom de la variable ======
Function return_ini_variable{
# cette fonction retourne la variable ini sans ca valeur 
# exemple "UseLinkTime=1" elle retourne seulement "UseLinkTime"
param
(
	[Parameter(mandatory=$true)]
	$string_to_process # la chaine a modifier
)

	$y=$string_to_process.split('=')[0]
	return $y

}
	
#==============================================================
Function ADD_string{
# une fonction qui recoit un chemin de fichier et une chaine a recherher, puis ajouter une ligne avant cette derniére
param
(
	[Parameter(mandatory=$true)]
	$Path_file, # le chemin du fichier à modifier 
	
	[Parameter(mandatory=$true)]
	[string]$string_to_check, # la chaine de caractére à recherher

	[Parameter(mandatory=$true)]
	[string]$textToAdd # la nouvelle ligne à ajouter
)

[int]$c=0 # le conteur pour suivre l'emplacement dans le fichier
[int]$position=0 #pour memoriser l'emplacement de la chaine recharchée

$temp_string=return_ini_variable -string_to_process $textToAdd #recuperer la valeur de la chaine avant le =

	 if ((Get-Content $Path_file) -match $temp_string+'=[0-9]')#verification avec un regex si la valeur existe deja dans le fichier 
		{
			
		write-host "une ligne avec la variable [" $temp_string "] existe deja  dans ["$Path_file.FullName "]" -ForegroundColor yellow
			
		}
		else
		{
		(Get-Content -path $Path_file) | Foreach-Object {$c++ ; if ($_ -eq $string_to_check){$position=$c}}
		
		
				$fileContent = Get-Content $Path_file
				$fileContent[$position-2] += "`r" + $textToAdd # Ajouter un retour à la ligne `r et ajouter la nouvelle ligne à la position demandée
				$fileContent | Set-Content $Path_file
				write-host "la ligne [" $textToAdd "] a ete ajoutee dans ["$Path_file.FullName "]" -ForegroundColor Green
				Write-Log -Message "$textToAdd a ete ajoutee dans $Path_file.FullName "  -Severity Information # Ajout log
		
		}
}
#==============================================================
#==============================================================

Function Ajouter_ligne{
# cette fonction permet d'appliquer la moification sur l'ensemble des serveurs du fichier ./servers.txt
				param
				(
					[Parameter(mandatory=$true)]
					$Fichier_a_Inclure, # les fichiers à inclure dans la recharche 

					[Parameter(mandatory=$False)]
					$Fichier_a_EXclure, # les fichiers à exclure 

					[Parameter(mandatory=$true)]
					$NVariable_to_add, # la variable à ajouter dans une nouvelle ligne 

					[Parameter(mandatory=$true)]
					$Nvariable_to_check # la $NVariable_to_add vat se mettre à une ligne en haut du $Nvariable_to_check
					
				)

	$serversList=Get-Content -path "./servers.txt"
	
	
	write-host "`nNous allons ajouter la ligne ["$NVariable_to_add"] en haut de la ligne ["$Nvariable_to_check"] pour l'ensemble des fichiers ["$Fichier_a_Inclure"]"
	write-host "Ne pas inclure les fichiers :["$Fichier_a_EXclure"]"
	write-host "`Le traitement parcourt le chemin \\NomServeur\d$\data\ de la liste des serveurs suivante :"
	$serversList
	$Title = ""
	$Info = "`nvous valider le traitement ?"
	$options = [System.Management.Automation.Host.ChoiceDescription[]] @("&Oui", "&Quitter")
	[int]$defaultchoice = 1
	$opt = $host.UI.PromptForChoice($Title , $Info , $Options,$defaultchoice)
	switch($opt)
		{
	  0 { Write-Host "traitement en cours " -ForegroundColor Green	
					#============= Traitement d'Ajout d'une nouvelle ligne dans l'ensemble de l'arborescence =======
					foreach ($srv in $serversList)
					{
								$CheminAtraiter='\\'+$srv+'\d$\data\' #emeplacement de recherche des fichiers .ini

								
										# recherhe des ficheirs *.ini dans l'arborescence du $CheminAtraiter 
										$items = Get-ChildItem $CheminAtraiter -recurse -file -Include $Fichier_a_Inclure -Exclude $Fichier_a_EXclure
										
											foreach ($item in $items)
												{
												# appel de la fonction d'ajout de ligne
												
												ADD_string -Path_file $item -string_to_check $Nvariable_to_check -textToAdd $NVariable_to_add
												#$item | select fullname
												
												}
					}
					#=================================================================================================
		}
		
	  1 {Write-Host "Good Bye!!!" -ForegroundColor Green}
		}
}
Export-ModuleMember Ajouter_ligne

# Ajout d'une variable:

	#Ajouter_ligne -Fichier_a_Inclure "Navitia*.ini" -Fichier_a_EXclure "Navitia_Updater.ini" -NVariable_to_add 'UseLinkTime=1' -Nvariable_to_check '[LOG]'

	#Ajouter_ligne -Fichier_a_Inclure "Navitia*.ini" -Fichier_a_EXclure "Navitia_Updater.ini" -NVariable_to_add 'UseLinkTime=1' -Nvariable_to_check '[LOG]'




