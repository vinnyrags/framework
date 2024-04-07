#!/bin/bash

# Run composer update
composer update

# Remove "vinnyrags/child-theme" from composer.json
composer remove vinnyrags/child-theme

# Remove /wp-content/themes/child-theme/.git
rm -rf wp-content/themes/child-theme/.git

# Prompt the user for a project name
read -p "Enter project name (no capital letters, use hyphens instead of spaces): " projectName

# Change "name" in composer.json
sed -i "s/\"name\": \"vincentragosta\/project\"/\"name\": \"vincentragosta\/$(echo "$projectName" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')\"/" composer.json

# Rename themes/child-theme directory
mv wp-content/themes/child-theme wp-content/themes/$(echo "$projectName" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

# Update themes/{input value}/style.scss Theme Name
sed -i "s/Theme Name: Project/Theme Name: $(echo "$projectName" | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g')/" wp-content/themes/$(echo "$projectName" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')/style.scss

# Change Theme URI
sed -i "s/Theme URI: https:\/\/project.io/Theme URI: https:\/\/$(echo "$projectName" | tr '[:upper:]' '[:lower:]' | tr ' ' '-').io/" wp-content/themes/$(echo "$projectName" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')/style.scss

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
