# 📚 App Bibliothèque - Gestion Mobile

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white) ![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white) ![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white) ![iOS](https://img.shields.io/badge/iOS-000000?style=for-the-badge&logo=ios&logoColor=white)

## 📱 À propos du projet

Ce projet est une **application mobile de gestion de bibliothèque** développée avec le framework **Flutter**.

Elle permet de gérer efficacement un inventaire de livres et le suivi des emprunts via une interface fluide et moderne. Ce projet a été réalisé dans le cadre de mon Bachelor pour monter en compétence sur le développement mobile et le langage Dart.

🔗 **URL du dépôt :** [https://github.com/DavidChloe/Bibliotheque](https://github.com/DavidChloe/Bibliotheque)

---

## ✨ Fonctionnalités

* **Catalogue interactif :** Liste des ouvrages avec couvertures et détails.
* **Recherche & Filtres :** Retrouver rapidement un livre par titre, auteur ou genre.
* **Gestion des Stocks (CRUD) :** Ajout, modification et suppression de livres.
* **Suivi des emprunts :** Visualisation des livres disponibles et de ceux actuellement empruntés.
* **Interface UI/UX :** Design respectant les standards Material Design.

---

## 🛠️ Stack Technique

* **Framework :** Flutter (SDK stable)
* **Langage :** Dart
* **Architecture :** MVC / MVVM
* **Gestion d'état :** (Provider)
* **Persistance des données :** (SQLite)

---

## 🚀 Installation et Lancement

Pour tester l'application sur un émulateur ou un appareil physique :

### 1. Cloner le dépôt
```bash
git clone [https://github.com/DavidChloe/Bibliotheque.git](https://github.com/DavidChloe/Bibliotheque.git)
cd Bibliotheque
```

### 2. Installer les dépendances
Assurez-vous d'avoir Composer installé.
```bash
composer install
```

### 3. Configuration de la base de données
Créez un fichier .env.local à la racine du projet et configurez votre accès à la base de données :
Extrait de code :
```bash
DATABASE_URL="mysql://root:root@127.0.0.1:3306/nom_de_la_bdd?serverVersion=mariadb-10.4.10"
```

### 4. Création de la BDD et des tables
```bash
php bin/console doctrine:database:create
php bin/console doctrine:migrations:migrate
```
### 5. Chargement des données fictives (Fixtures)

Pour avoir des produits et des utilisateurs de test dès le départ :
```bash
php bin/console doctrine:fixtures:load
```
### 6. Lancer le serveur
```bash
symfony serve
```
L'application sera accessible sur `http://localhost:8000`.

---

## 👤 Auteurs

**David & Chloé** - Étudiants en Bachelor Développement Web.

---

## 📝 Licence

Projet académique.
