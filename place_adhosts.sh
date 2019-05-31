url="https://pgl.yoyo.org/adservers/serverlist.php?hostformat=unbound&showintro=1&mimetype=plaintext"
conf=/var/unbound/etc/adblocks.conf

#download list to dest and remove top 60 lines (html)
ftp -o $conf $url && \
sed -i 1,60d $conf && \
unbound-checkconf && \
unbound-control reload
