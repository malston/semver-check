#!/bin/bash

# Import the version comparison function
source ./version-compare.sh

# Colors for test output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

run_test() {
    local test_name="$1"
    local version1="$2"
    local version2="$3"
    local expected="$4"
    
    local result=$(compare_versions "$version1" "$version2")
    
    if [[ "$result" -eq "$expected" ]]; then
        echo -e "${GREEN}✓${NC} $test_name passed"
        return 0
    else
        echo -e "${RED}✗${NC} $test_name failed"
        echo "  Expected: $expected"
        echo "  Got: $result"
        echo "  Comparing: $version1 vs $version2"
        return 1
    fi
}

# Test counter
total_tests=0
passed_tests=0

run_and_count() {
    ((total_tests++))
    if run_test "$@"; then
        ((passed_tests++))
    fi
}

echo "Running version comparison tests..."
echo "================================="

# Basic version comparisons
run_and_count "Equal versions" "1.2.3" "1.2.3" 0
run_and_count "Simple greater than" "1.2.4" "1.2.3" 1
run_and_count "Simple less than" "1.2.3" "1.2.4" -1

# Different number of components
run_and_count "More components greater" "1.2.3.1" "1.2.3" 1
run_and_count "More components equal base" "1.2.3.0" "1.2.3" 1
run_and_count "Fewer components less" "1.2" "1.2.1" -1

# Zero handling
run_and_count "Leading zeros equal" "1.02.3" "1.2.3" 0
run_and_count "Multiple zeros" "1.0.0" "1.0.0" 0
run_and_count "Zero vs non-zero" "1.0.1" "1.0.0" 1

# Major version differences
run_and_count "Major version greater" "2.0.0" "1.9.9" 1
run_and_count "Major version less" "1.9.9" "2.0.0" -1

# Minor version differences
run_and_count "Minor version greater" "1.3.0" "1.2.9" 1
run_and_count "Minor version less" "1.2.9" "1.3.0" -1

# Large numbers
run_and_count "Large version numbers" "10.20.30" "10.20.29" 1
run_and_count "Very large numbers" "999.999.999" "999.999.998" 1

# Edge cases
run_and_count "Zero vs one" "0.0.0" "0.0.1" -1
run_and_count "Complex mixed comparison" "2.0.0" "1.9999.9999" 1

# Summary
echo "================================="
echo "Test Summary:"
echo "Total tests: $total_tests"
echo "Passed: $passed_tests"
echo "Failed: $((total_tests - passed_tests))"

if [[ "$passed_tests" -eq "$total_tests" ]]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
fi