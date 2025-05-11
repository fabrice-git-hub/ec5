# Node.js + Ansible + Terraform Deployment

•	Création branche "test" sur  le VCS et une "Organisation Test" sur Terraform Cloud

•	Dans l’organisation test créer un Workspace connecté à la branche "test" du repo

•	Créer une application node.js

	o	 Faire tourner l’application sur la machine pour être sûr qu’elle marche comme souhaité
		- https://nodejs.org/en/docs/guides/getting-started-guide/
		- https://nodejs.org/en/download/ 
	o	Faire en sorte que la réponse à la requête “/” contient la variable d'environnement ENVIRONMENT_NAME.
Voir le paquet npm nommée “dotenv”

•	Provisionner un playbook Ansible dépendant de l’instance qui devra :
	o	Update et upgrade les paquets à l’initialisation
	o	Installer nginx et nodejs
	o	Créer un fichier de configuration nginx mettant en place un reverse proxy redirigeant les requêtes reçus au port 80 vers localhost :3000
	o	Lancer nginx
	o	Ajouter une variable d'environnement nommée ENVIRONMENT_NAME qui dans la branche test aura la valeur test et sur master (main) la valeur prod
	o	Lancer l’application avec nodejs sur le port 300
	o	Lancez les workflows prod et test, vérifier l'accès aux deux sites web, l’un renvoyant un message contenant le mot test et l’autre prod

•	Livrables : Deux serveurs chacun dans un environnement différent consultable via internet et facilement différenciable
  
## Environnements déployés

	- Test: http://<IP_TEST>
	- Prod: http://<IP_PROD>