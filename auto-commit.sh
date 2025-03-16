#!/bin/bash

while true; do
    # Değişiklikleri kontrol et
    if [[ $(git status --porcelain) ]]; then
        echo "Değişiklikler bulundu, GitHub'a yükleniyor..."
        
        # Değişiklikleri ekle
        git add .
        
        # Commit oluştur (tarih ve saat ile)
        git commit -m "Otomatik commit: $(date '+%Y-%m-%d %H:%M:%S')"
        
        # GitHub'a gönder
        git push
        
        echo "Değişiklikler GitHub'a yüklendi!"
    else
        echo "Değişiklik yok, bekleniyor..."
    fi
    
    # 5 dakika bekle
    sleep 300
done 