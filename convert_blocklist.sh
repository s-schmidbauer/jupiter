#convert notracking hosts and domains list into unbound format. takes plenty of memory. 

#https://raw.githubusercontent.com/notracking/hosts-blocklists/master/hostnames.txt
#example:
#local-zone: "51yes.com" redirect
#local-data: "51yes.com A 127.0.0.1"

for m in $(grep 0.0.0.0 $2 | cut -d' ' -f2); do \
echo 'local-zone: "'$m'" redirect'; \
echo 'local-data: "'$m 'A 127.0.0.1"'; \
done

#https://raw.githubusercontent.com/notracking/hosts-blocklists/master/domains.txt
#example:
#address=/dulderbulder.com/0.0.0.0
#address=/dulderbulder.com/::

for m in $(grep 0.0.0.0 $2 | cut -d'/' -f2); do \
echo 'local-zone: "'$m'" redirect'; \
echo 'local-data: "'$m 'A 127.0.0.1"'; \
done
