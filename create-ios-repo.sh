#!/bin/bash

# Proje adını parametre olarak al
PROJECT_NAME=$1

if [ -z "$PROJECT_NAME" ]; then
    echo "Lütfen proje adını girin. Örnek: ./create-ios-repo.sh ProjeAdi"
    exit 1
fi

# GitHub'da yeni repo oluştur
echo "GitHub'da repo oluşturuluyor: $PROJECT_NAME"
gh repo create "$PROJECT_NAME" --private --clone

# Proje dizinine git
cd "$PROJECT_NAME"

# .gitignore dosyasını oluştur
curl -o .gitignore https://raw.githubusercontent.com/github/gitignore/master/Swift.gitignore

# İlk commit
git add .
git commit -m "Initial commit"
git push -u origin main

# Auto Git kurulumu
code . # VS Code'u aç
echo "VS Code açıldıktan sonra:"
echo "1. Command Palette'i açın (Cmd + Shift + P)"
echo "2. Auto-Git: Init yazın ve çalıştırın"
echo "3. Auto-Git: Start yazın ve çalıştırın"

echo "✅ Repo oluşturuldu ve Auto Git için hazır!" 