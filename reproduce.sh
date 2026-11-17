#!/usr/bin/env bash
# Reproduce the analysis in one command.
#
#   ./reproduce.sh          Replays the analysis from the saved tables in resultats/data
#                           (a few minutes): detector check, threshold sweep, figures.
#   ./reproduce.sh --full   First reruns all simulations under separate tags and checks
#                           that they give back the saved tables exactly (about 1 h on 10 cores).
#
# Python 3.12 with the packages of requirements.txt (river 0.23.0).
# Another interpreter: PYTHON=/path/to/python ./reproduce.sh
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
PY="${PYTHON:-python3}"
export PYTHONHASHSEED=0 MPLBACKEND=Agg
FULL=0; [ "${1:-}" = "--full" ] && FULL=1
step() { printf '\n=== %s ===\n' "$1"; }

cd "$HERE/scripts"

if [ "$FULL" = 1 ]; then
  step "Simulations (new tags, nothing is overwritten)"
  "$PY" -c "import river, sys; sys.exit(0 if river.__version__ == '0.23.0' else 'river 0.23.0 required')"
  "$PY" exp_QCD_campagne.py --full --tag repro
  "$PY" exp_QCD_campagne.py --full --no-drift --seeds 2000 --tag repro2000
  "$PY" exp_QCD_etalon.py --full --tag repro
  "$PY" analyse_QCD.py --tag repro_M10 --boot 2000
  step "Comparison with the saved tables"
  "$PY" compare_reproduction.py --nettoyer
fi

step "Check of the rebuilt detector (closed form vs recursion)"
"$PY" analyse_QCD.py --self-check

step "Threshold sweep (in time / fires / false alarms)"
"$PY" balayage_lambda.py
"$PY" balayage_lambda.py --temoin QE2000_nodrift_M10

step "Correlation matrix of the indicators"
"$PY" matrice_correlations.py

step "Done"
