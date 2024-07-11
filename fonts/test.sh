mkdir -p 'test'
for i in `ls *.zip`;
  do \
    unzip -o "$i"
    mv *.ttf test/
  done 
