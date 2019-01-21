# Makes a list of IPv4 from logs to be added to pf tables.
##########################################################
# Get IPv4 from log ($1), insert it into pf table ($) while excluding IP4 from ($5). 
# Save temporarily to file ($3).
# Copy temp file to pf table file ($4). 
# Commit pf table file to git repo in /etc ($4)
# Check if pf config check returns OK, then reload
 
# Usage: failed_ips.sh /var/log/authlog mofos pf.mofos /etc/pf.mofos /etc/white 
# Usage: failed_ips.sh /var/log/relayd webmofos pf.webmofos /etc/pf.webmofos /etc/white

echo "get IPv4s from $1"

if [[ $1 = "/var/log/relayd" ]]
then
	echo "relayd log"
	ips=$(cat $1 \
	| grep -E '\(403|Forbidden|handshake error:' \
	| grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' \
	| grep -v -f /etc/white \
	| sort \
	| uniq)
else
	echo "authlog"
	ips=$(cat $1 \
	| grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' \
	| grep -v -f /etc/white \
	| sort \
	| uniq)
fi	


echo "add IPv4s to $2 pf table"
for ip in $ips ; do doas pfctl -t $2 -T add $ip > /dev/null 2>&1 ; done

echo "dump $2 pf table to file $3"
doas pfctl -t $2 -T show > $3

echo "copy temp file $3 to persistent file $4"
doas cp $3 $4

echo "check pf.conf"
if doas pfctl -nf /etc/pf.conf; then
	echo "reload pf"
	doas pfctl -f /etc/pf.conf
fi

echo "git commit file"
cd /etc ; doas git add $4 ; doas git commit -am 'update pf table'
