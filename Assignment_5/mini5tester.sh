#!/bin/bash



check_for_source()
{
    if [[ ! -f "$1" ]]
    then
        echo "Source file '$1' not found. Please make sure to upload the mini tester script into the same folder as your source files."
        exit 1;
    fi
}

print_and_run()
{
    echo "\$ $1"
    bash -c "$1"
    echo -e "exit code: $?"
}

create_random_number()
{
    max_length=$1
    nb_bytes=$((max_length/2))
    [[ $nb_bytes < 1 ]] && nb_bytes=1
    random_number=$(dd if=/dev/urandom ibs=1 count=$((2*nb_bytes)) 2>/dev/null | xxd -p | sed -e 's/[a-f]//g' -e 's/^0\+//' | tr -d '\n')
    random_number=${random_number::$max_length}
    echo ${random_number:-0}
}

check_for_source "report.c"

# BEGIN SETUP
sourcedir=$PWD
tmpdir=/tmp/__tmp_comp206_${LOGNAME}
mkdir -p "$tmpdir"
cp report.c "$tmpdir"
cp data.csv "$tmpdir"

cd "$tmpdir"



echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  report.c tests @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo
echo "[[[[ test case 0: compiling report.c ]]]]"
echo "********************************************************************************"
print_and_run "gcc -o report report.c"
echo "********************************************************************************"
echo
echo "[[[[ test case 1: EXPECTED TO FAIL - missing parameter ]]]]"
echo "********************************************************************************"
print_and_run "./report data.csv"
echo "********************************************************************************"
echo
echo "[[[[ test case 2: EXPECTED TO FAIL - wrong input file ]]]]"
echo "********************************************************************************"
print_and_run "./report nosuchdata.csv 'Jane Doe' rpt.txt"
echo '********************************************************************************'
echo
echo "[[[[ test case 3: EXPECTED TO FAIL - non existing student ]]]]"
echo '********************************************************************************'
print_and_run "./report data.csv 'Jane Doe' rpt.txt"
echo '********************************************************************************'
echo

echo "[[[[ special test case: EXPECTED TO FAIL - unable to open output file ]]]]"
echo '********************************************************************************'
touch rpt.txt "$tmpdir"
chmod -rwx rpt.txt
print_and_run "./report data.csv 'Markus Bender' rpt.txt"
chmod +rwx rpt.txt
echo

echo "[[[[ test case 4: EXPECTED TO WORK ]]]]"
echo '********************************************************************************'
print_and_run "./report data.csv 'Markus Bender' rpt.txt"
cat rpt.txt
echo
echo "[[[[ test case 5: EXPECTED TO WORK ]]]]"
echo '********************************************************************************'
print_and_run "./report data.csv 'Adaline Murphy' rpt.txt"
cat rpt.txt
