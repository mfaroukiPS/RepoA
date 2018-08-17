# script qui permet de supprimer une ligne spécifique dans une arborescence 
import-module .\WriteLog.psm1 -force
$serveurNavitia='localhost'
$CheminAtraiter='\\'+$serveurNavitia+'\c$\data\' #emeplacement de recherche des fichiers .ini




Function delete_string{
# une fonction qui recoit un chemin de fichier et une chaine a recherher et supprimer ca ligne 
param
(
	[Parameter(mandatory=$true)]
	$Path_file, # le chemin du fichier à modifier 
	
	[Parameter(mandatory=$true)]
	[string]$string_to_delete # la chaine de caractére à recherher


)


	 if ((Get-Content -path $Path_file.FullName) -match $string_to_delete)#verification de la ligne 
		{
			
		
		$fichier = Get-Content -path $Path_file.FullName | Where-Object {$_ -notmatch $string_to_delete}
		$fichier | Set-Content $Path_file
		write-host "la ligne [" $string_to_delete "] a ete supprimee du fichier ["$Path_file.FullName "]" -ForegroundColor Green
		Write-Log -Message "$string_to_delete a ete supprimee du fichier $Path_file.FullName "  -Severity Information # Ajout log
			
		}
		else
		{
			write-host "la ligne [" $string_to_delete "] n'existe pas dans ["$Path_file.FullName "]" -ForegroundColor yellow
			
		}
}

#==============================================================

Function Supprimer_ligne{
# cette fonction permet de supprimer la ligne de la variable envoyé $NVariable_to_delete
				param
				(
					[Parameter(mandatory=$true)]
					$Fichier_a_Inclure, 

					[Parameter(mandatory=$False)]
					$Fichier_a_EXclure,

					[Parameter(mandatory=$true)]
					$NVariable_to_delete

				)

				
$serversList=Get-Content -path "./servers.txt"

	write-host "`nNous allons supprimer la ligne ["$NVariable_to_delete"] pour l'ensemble des fichiers ["$Fichier_a_Inclure"]"
	write-host "Ne pas inclure les fichiers :["$Fichier_a_EXclure"]"
	write-host "`Le traitement va prcourire le chemin \\NomServeur\d$\data\ de la liste des serveurs suivante :"
	$serversList
	$Title = ""
	$Info = "`nvous valider le traitement ?"
	$options = [System.Management.Automation.Host.ChoiceDescription[]] @("&Oui", "&Quitter")
	[int]$defaultchoice = 1
	$opt = $host.UI.PromptForChoice($Title , $Info , $Options,$defaultchoice)
	switch($opt)
		{
			  0 { Write-Host "traitement en cours " -ForegroundColor Green	




							foreach ($srv in $serversList)
							{
									$CheminAtraiter='\\'+$srv+'\d$\data\' #emeplacement de recherche des fichiers .ini


									#==== Traitement de suppression d'une nouvelle ligne dans l'ensemble de arborescence  =======
									# recharhe des ficheirs *.ini dans l'arborescence du $CheminAtraiter 
									$items = Get-ChildItem $CheminAtraiter -recurse -file -Include $Fichier_a_Inclure -Exclude $Fichier_a_EXclure

									foreach ($item in $items)
									{
									# appel de la fonction d'ajout de ligne 		
									delete_string -Path_file $item -string_to_delete $NVariable_to_delete
									
									}

									#==============================================================
							}
				}
					  1 {Write-Host "Good Bye!!!" -ForegroundColor Green}
		}					
				
				
 }
 
 Export-ModuleMember Supprimer_ligne
 
  #supprimer la ligne ajouté:

	#Supprimer_ligne -Fichier_a_Inclure "Navitia*.ini" -Fichier_a_EXclure "Navitia_Updater.ini" -NVariable_to_delete 'UseLinkTime=1'
 
 
 