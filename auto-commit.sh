#!/bin/bash

# Script her çalıştığında geçerli dizine git
cd "$(dirname "$0")"

# Sonsuz döngü - script sürekli çalışacak
while true; do
    # Değişiklikleri kontrol et
    if [[ $(git status --porcelain) ]]; then
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Değişiklikler bulundu, GitHub'a yükleniyor..."
        
        # Değişiklikleri staging'e ekle
        git add .
        
        # Değişiklikleri commit'le
        git commit -m "Otomatik commit: $(date '+%Y-%m-%d %H:%M:%S')"
        
        # GitHub'a gönder
        git push
        
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Değişiklikler GitHub'a yüklendi!"
    else
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Değişiklik yok, bekleniyor..."
    fi
    
    # 60 saniye bekle
    sleep 60
done 