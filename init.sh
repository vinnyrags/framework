#!/bin/bash

# Run composer update without interaction
composer update --no-interaction

# Remove "vinnyrags/child-theme" from composer.json
sed -i '' '/"vinnyrags\/child-theme"/d' composer.json

# Remove /wp-content/themes/child-theme/.git
rm -rf wp-content/themes/child-theme/.git

# Prompt the user for a project name
read -p "Enter project name: " projectName

# Change "name" in composer.json
sed -i '' "s/\"name\": \"vinnyrags\/project\"/\"name\": \"vinnyrags\/$(echo "$projectName" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')\"/" composer.json

# Rename themes/child-theme directory
mv wp-content/themes/child-theme wp-content/themes/$(echo "$projectName" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

# Update themes/{input value}/style.scss Theme Name
sed -i '' "s/Theme Name: Project/Theme Name: $(echo "$projectName" | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g')/" wp-content/themes/$(echo "$projectName" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')/style.scss

# Change Theme URI
sed -i '' "s/Theme URI: https:\/\/project.io/Theme URI: https:\/\/$(echo "$projectName" | tr '[:upper:]' '[:lower:]' | tr ' ' '-').io/" wp-content/themes/$(echo "$projectName" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')/style.scss

# Prompt the user to enter the new project git url
read -p "Enter the new project git URL: " gitUrl

# Update the git remote URL
cd wp-content/themes/$(echo "$projectName" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
git remote set-url origin "$gitUrl"
cd ../..

# Git commit and push
git add .
git commit -m "Initial commit"
git push
