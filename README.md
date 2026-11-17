# Revisiting the Blind Spot Paradox

Code and data behind our poster *Can a self-repairing model silence its own alarm?*
(EUGLOH workshop "AI and One Health", November 2026). The poster is in [`poster/`](poster/).

Alexandre Boyer, Salomé Fonvielle, Melaine Gouillou, Ulysse Petit-Tichanné, supervised by
Raphaël Minato (LISN). Research track, CentraleSupélec, Université Paris-Saclay.

## The question

An Adaptive Random Forest (10 trees, `river`) replaces a tree when its error rises: the model
repairs itself after a change in the data (concept drift). A CUSUM detector (Page–Hinkley) watches
the overall error and raises an alarm when the accumulated evidence reaches a threshold λ.
The original paper (Minato, Popineau, Rimmel & Doan, *The Blind Spot Paradox: When Adaptive
Classifiers Defeat Drift Detectors*, arXiv:2610.05853) reports that the repair can hide the change
from the alarm. We reproduced, corrected and extended that study.

## Main results (2,000 simulated runs with drift, 2,000 without)

- **The race identity.** The alarm comes before the first repair exactly when the evidence piled up
  before that repair reaches the threshold: true in 2,000 runs out of 2,000.
- **Beyond a medium change, a stronger change leaves less evidence.** The median evidence falls from
  19.8 to 13.1. At λ = 15 the alarm is in time in 81 % of the runs for a medium change and in 18 %
  for the strongest one.
- **An alarm that fires is not an alarm in time.** At λ = 15 the alarm fires in 92.9 % of the runs
  but before the repair in only 36.3 %.
- **The repair also fires on noise.** With no change at all, a tree is replaced after 95 steps
  (median), sooner than after a small real change (118).

All data are simulated, with abrupt changes only.

## Contents

- `scripts/`: simulations (`exp_QCD_campagne.py`, `exp_QCD_etalon.py`, `exp_QCD_temoins_bruit.py`)
  and analysis (`analyse_QCD.py`, `balayage_lambda.py`, `matrice_correlations.py`,
  `compare_reproduction.py`). Comments are in French.
- `resultats/data/`: the saved tables (parquet) and campaign logs.
- `resultats/figures/`: the figures produced by the scripts.
- `poster/`: the poster (A0, PDF).

## Reproduce

```bash
python3.12 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
./reproduce.sh          # replays the analysis from the saved tables (a few minutes)
./reproduce.sh --full   # reruns the simulations first and checks they match the tables (~1 h on 10 cores)
```

`river==0.23.0` has no prebuilt wheel for some platforms (e.g. macOS x86_64 with Python 3.12): pip
then builds it from source and needs a Rust compiler.

The simulations reuse the setting of the official experiments repository of the original paper:
https://github.com/TheBlindSpot-ICDM2026/The-Blind-Spot-Paradox-Experiments
(commit `9d28823976c0563ef955eb95a5efeccd7d7c4492`).
