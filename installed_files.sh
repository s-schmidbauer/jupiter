
echo "list installed packages files"
for i in $(pkg_info -a) ; do pkg_info -L $i ; done

# search in packages
#i=search ; do for p in $(pkg_info -Q $i); do pkg_info -L $p ; done ; done 
