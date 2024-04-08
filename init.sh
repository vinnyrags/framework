#!/bin/bash

read -p "Enter Project Name: " projectName
projectSlug=$(echo "$projectName" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
projectTitle=$(echo "$projectName" | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1')
projectNamespace=$(echo $projectTitle | tr -d ' ')

echo "Installing Plugins..."
composer update
echo "Plugins installed."

echo "Initializing $projectSlug theme..."
sed -i '' "s/Theme Name:.*$/Theme Name: $projectTitle/" wp-content/themes/child-theme/style.css
sed -i '' "s/Theme URI:.*$/Theme URI: https:\/\/$projectSlug.io/" wp-content/themes/child-theme/style.css
sed -i '' "s/project-slug/$projectSlug/g" composer.json
sed -i '' "s/projectSlug/$projectNamespace/g" composer.json
mv wp-content/themes/child-theme wp-content/themes/$projectSlug
rm -rf wp-content/themes/$projectSlug/.git
rm -rf wp-content/themes/$projectSlug/.gitignore
rm -rf wp-content/themes/$projectSlug/composer.json
echo "$projectSlug theme initialized..."

read -p "Enter New Git Repository SSH url: " gitRepoUrl
git remote set-url origin $gitRepoUrl
git add --all
git commit -m "initial commit"
git branch -M main
git push origin main

rm init.sh