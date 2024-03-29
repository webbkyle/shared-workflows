#!/bin/bash
set -e
# Input parameter: expected code coverage threshold
desired_coverage=$1

# Run the tests using pytest with coverage
python -m pip install --upgrade pip
pip install flake8 pytest
if [ -f requirements.txt ]; then pip install -r requirements.txt; fi

# stop the build if there are Python syntax errors or undefined names
flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
# exit-zero treats all errors as warnings. The GitHub editor is 127 chars wide
flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics

# Run the tests using pytest with coverage
pytest --cov=. --cov-report=term-missing

# Check the coverage level against the desired coverage
coverage=$(coverage report -m | grep -oP '\d+.\d+(?=%)')

if (( $(echo "$coverage < $desired_coverage" |bc -l) )); then
  echo "Test coverage of ${coverage}% is below the desired coverage of ${desired_coverage}%"
  exit 1
else
  echo "Test coverage of ${coverage}% is at least the desired coverage of ${desired_coverage}%"
fi

echo "test_coverage=$(echo $coverage_pct)" >> $GITHUB_OUTPUT
echo "test_status=$(echo PASS)" >> $GITHUB_OUTPUT