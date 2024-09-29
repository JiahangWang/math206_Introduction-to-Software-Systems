# test 1: not divisible & not increasing
./divisible <<< "10 5 7"
echo "*** expected: Not divisible & Not increasing"
# test 2: Divisible and Increasing
./divisible <<< "3 6 9"
echo "*** expected: Divisible & Increasing"
# test 3: Divisible and not increasing
./divisible <<< "5 20 10"
echo "*** expected: Divisible & Not increasing"
# end of tester
echo "END OF TESTING SCRIPT"

