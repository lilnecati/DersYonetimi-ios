#!/bin/bash


cd "$(dirname "$0")"

while true; do

    if [[ $(git status --porcelain) ]]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Değişiklikler bulundu, GitHub'a yükleniyor..."
        
        git add .
        
        git commit -m "Otomatik commit: $(date '+%Y-%m-%d %H:%M:%S')"
        
        git push
        
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Değişiklikler GitHub'a yüklendi!"
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Değişiklik yok, bekleniyor..."
    fi
    

    sleep 60
done 