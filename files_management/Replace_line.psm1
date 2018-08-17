#ISO 8859-8
#Script pour chercher et modifier une chaine de caractére dans les fichier .ini d'une arborescence donné 
import-module .\WriteLog.psm1 -force
$serveurNavitia='localhost'
$CheminAtraiter='\\'+$serveurNavitia+'\c$\data\' #emeplacement de recherche des fichiers .ini
#==============================================================
Function modify_string{
# une fonction qui recoit un chemin de fichier et une chaine a recharher par une autre
param
(
	[Parameter(mandatory=$true)]
	$Path_file, # le chemin du fichier à modifier 
	
	[Parameter(mandatory=$true)]
	[string]$string_tomodify, # la chaine de caractére à modifier

	[Parameter(mandatory=$true)]
	[string]$New_string # la nouvelle chaine à mettre en place
)
		#write-host $Path_file -ForegroundColor green
	 if ((Get-Content $Path_file.FullName).Contains($string_tomodify))
					{	
						(Get-Content -path $Path_file.FullName) | Foreach-Object { $_ -replace $string_tomodify, $New_string } | Set-Content $Path_file.FullName
						write-host "la ligne [" $string_tomodify  "] a ete modifie par ["  $New_string " ] dans le fichier [" $Path_file.FullName " ]" -ForegroundColor Green
						Write-Log -Message "$string_tomodify a ete modifie par $New_string dans le fichier $Path_file.FullName "  -Severity Information # Ajout log
					}
					else
					{
						write-host "le fichier [ " $Path_file.FullName " ] ne contient pas la ligne [" $string_tomodify "]"  -ForegroundColor yellow
					}
}
#==============================================================


Function modifier_ligne{
# cette fonction permet de modifier la ligne de la variable envoyé $NVariable_to_delete
				param
				(
					[Parameter(mandatory=$true)]
					$Fichier_a_Inclure, 

					[Parameter(mandatory=$False)]
					$Fichier_a_EXclure,

					[Parameter(mandatory=$true)]
					$NVariable_a_replacer,
					
					[Parameter(mandatory=$true)]
					$NVariable_de_remplacement

				)

				
$serversList=Get-Content -path "./servers.txt"

	write-host "`nNous allons modifier la ligne ["$NVariable_a_replacer"] par la ligne ["$NVariable_de_remplacement"] pour l'ensemble des fichiers ["$Fichier_a_Inclure"]"
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
										#===== Traitement des changements de la chaine recherchée dans l'ensemble de l'arborescence =======
										# recherhe des ficheirs *.ini dans l'arborescence du $CheminAtraiter 
										$items = Get-ChildItem $CheminAtraiter -recurse -file -Include $Fichier_a_Inclure -Exclude $Fichier_a_EXclure
										
										foreach ($item in $items)
										{
										# appel de la fonction de changement de chaine 		
											modify_string -Path_file $item -string_tomodify $NVariable_a_replacer -New_string $NVariable_de_remplacement
										}
							#==================================================================================================
							}
				}
							
			  1 {Write-Host "Good Bye!!!" -ForegroundColor Green}
		}					

}

Export-ModuleMember modifier_ligne

#modifier la ligne ajouté: 
	
	#modifier_ligne -Fichier_a_Inclure "Navitia*.ini"  -Fichier_a_EXclure "Navitia_Updater.ini"  -NVariable_a_replacer 'UseLinkTime=1' -NVariable_de_remplacement 'UseLinkTime=0'




