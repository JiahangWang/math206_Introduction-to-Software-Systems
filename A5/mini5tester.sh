#!/bin/bash
echo "--- setting up the environment ---"
rm -f phonebook.csv
make
echo
echo "--- assignment description example test ---"
./phonebook << INPUT
3
echo "*** expect to see: Phonebook.csv does not eist"
1
Bob Smith
2000-01-15
514-333-4444
1
Mary Zhang
1999-05-20
1-234-567-1234
3
echo "*** expect to see phone book listing is pretty"
2
Mary Zhang
echo "*** expect to see Mary displayed in pretty format"
2
Tom Bombadil
echo "*** expect to see: Does not exist"
4
echo "*** expect to see: End of phonebook program"
echo
echo "---- TEST SCRIPT DONE ----"
echo "Note: TA will add additional tests. You should too."
INPUT

