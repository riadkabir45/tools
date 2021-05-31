#!/bin/sh
. ./enhance.lib
workdir="romsbuilddir"
mkdir -p "$workdir"
mkdir -p "$workdir/roms"

[ ! -e "$workdir/roms.txt" ] && curl -s https://romsmania.cc/roms | grep "https://romsmania.cc/roms/" | sed 's/<a href="//g' | sed 's|</a>||g' | sed 's/">/;/g' | grep -v "dropdown__link" > "$workdir/roms.txt"

OIFS="$IFS"
IFS='
'
for cons_url in $(cat "$workdir/roms.txt" | grep -oE "^[^;]+")
do
  cons_name=$(basename $cons_url)
  [ ! -e "$workdir/roms/$cons_name.txt" ] && curl "$cons_url" > "$workdir/roms/$cons_name.txt"
done
IFS="$OIFS"

#> "$workdir/cons.txt"
OIFS="$IFS"
IFS='
'
for cons in $(cat "$workdir/roms.txt")
do
  cons_url=$(echo "$cons" | grep -oE "^[^;]+")
  cons_title=$(echo "$cons" | grep -oE "[^;]+$")
  cons_name=$(basename $cons_url)
  #[ ! -e "$workdir/roms/$cons_name.txt" ] && curl "$cons_url" > "$workdir/roms/$cons_name.txt"
  cons_page_n=$(grep -E "data-page=\"[0-9]+\"" "$workdir/roms/$cons_name.txt" | grep -v "Next page" | tail -n 1 | grep -oE "[0-9]+" || echo "1")
  echo "$cons_url;$cons_title;$cons_page_n"
done > "$workdir/cons.txt"
IFS="$OIFS"

OIFS="$IFS"
IFS='
'
for cons in $(cat "$workdir/cons.txt")
do
  cons_url=$(echo "$cons" | grep -oE "^[^;]+")
  cons_name=$(echo "$cons" | grep -oE ";[^;]+;" | grep -oE "[^;]+")
  cons_n=$(echo "$cons" | grep -oE "[^;]+$")
  for i in $(iterate 1 "$cons_n" | tr ' ' '\n')
  do
    [ -e "$workdir/romlinks/$cons_name/$i.txt" ] && continue
    url="$cons_url?page=$i"
    mkdir -p "$workdir/romlinks/$cons_name/"
    echo "$cons_name:$i/$cons_n"
    curl $url>"$workdir/romlinks/$cons_name/$i.txt"
  done
done
IFS="$OIFS"

mkdir -p "romhtml"

cat<<EOF>"rom_index.html"
<html>
	<head>
		<title>RomsMania</title>
		<script>
			function myFunction() {
			// Declare variables
		    var input, filter, table, tr, td, i, txtValue;
		    input = document.getElementById("myInput");
  		    filter = input.value.toUpperCase();
  		    table = document.getElementById("romTable");
  		    tr = table.getElementsByTagName("tr");

  		    // Loop through all table rows, and hide those who don't match the search query
  		    for (i = 0; i < tr.length; i++) {
					td = tr[i].getElementsByTagName("td")[0];
					if (td) {
						txtValue = td.textContent || td.innerText;
						if (txtValue.toUpperCase().indexOf(filter) > -1) {
							tr[i].style.display = "";
						} else {
							tr[i].style.display = "none";
						}
					}
				}
		    }
        </script>
	</head>
	<body align="center">
		<input type="text" id="myInput" onkeyup="myFunction()" placeholder="Search for names..">
		<table align="center" id="romTable">
			<th>Console</th>
EOF

OIFS="$IFS"
IFS='
'
for romlib in $workdir/romlinks/*
do
	console_title="$(basename $(echo "$romlib"))"
	cat<<EOF>>"rom_index.html"
			<tr>
				<td><a href="romhtml/$console_title.html">$console_title</a></td>
			</tr>
EOF
	cat<<EOF>"romhtml/$console_title.html"
<html>
	<head>
		<title>RomsMania</title>
		<script>
			function myFunction() {
			// Declare variables
		    var input, filter, table, tr, td, i, txtValue;
		    input = document.getElementById("myInput");
  		    filter = input.value.toUpperCase();
  		    table = document.getElementById("romTable");
  		    tr = table.getElementsByTagName("tr");

  		    // Loop through all table rows, and hide those who don't match the search query
  		    for (i = 0; i < tr.length; i++) {
					td = tr[i].getElementsByTagName("td")[0];
					if (td) {
						txtValue = td.textContent || td.innerText;
						if (txtValue.toUpperCase().indexOf(filter) > -1) {
							tr[i].style.display = "";
						} else {
							tr[i].style.display = "none";
						}
					}
				}
		    }
        </script>
	</head>
	<body align="center">
		<input type="text" id="myInput" onkeyup="myFunction()" placeholder="Search for names..">
		<table align="center" id="romTable">
			<th>Name</th>
EOF
	for romsdata in $(cat romsbuilddir/romlinks/$console_title/*.txt | grep -E "https://romsmania.cc/roms/[^/]+/" | grep -v -e "dropdown__link" -e "class=" | sort | uniq)
	do
		url=$(echo $romsdata|grep -oE "https://romsmania.cc/roms[^\"]+")
		name=$(echo $romsdata|grep -oE ">[^<^>]+<"|grep -oE "[^<^>]+")
		cat<<EOF
			<tr>
				<td><a href="$url">$name</a></td>
			</tr>
EOF
		#https://romsmania.cc/roms
	done>>"romhtml/$console_title.html"
	cat<<EOF>>"romhtml/$console_title.html"
</table>
	</body>
</html>
EOF
done
IFS="$OIFS"
cat<<EOF>>"rom_index.html"
</table>
	</body>
</html>
EOF
