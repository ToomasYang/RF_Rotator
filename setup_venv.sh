#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV_DIR="${1:-$HOME/venv}"
PYTHON_BIN="${PYTHON_BIN:-python3}"

echo "[1/4] Checking Python interpreter: ${PYTHON_BIN}"
if ! command -v "${PYTHON_BIN}" >/dev/null 2>&1; then
  echo "Error: ${PYTHON_BIN} not found. Install Python 3 first." >&2
  exit 1
fi

echo "[2/4] Creating virtual environment: ${VENV_DIR}"
"${PYTHON_BIN}" -m venv "${VENV_DIR}"

echo "[3/4] Upgrading pip/setuptools/wheel"
"${VENV_DIR}/bin/python" -m pip install --upgrade pip setuptools wheel

echo "[4/4] Installing dependencies from requirements.txt"
"${VENV_DIR}/bin/pip" install -r "${SCRIPT_DIR}/requirements.txt"

echo
echo "Setup complete."
echo "Activate with: source ${VENV_DIR}/bin/activate"
echo "Run app with:  ${VENV_DIR}/bin/python ${SCRIPT_DIR}/rf_rotator"