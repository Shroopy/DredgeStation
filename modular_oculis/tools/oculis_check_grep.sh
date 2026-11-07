#!/bin/bash

#ANSI Escape Codes for colors to increase contrast of errors
RED="\033[0;31m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

echo -e "${BLUE}Re-running grep checks, but looking in modular_oculis...${NC}"

# Run the linters again, but modular Oculis code.
sed "s|code/\*\*/\*\.dm|modular_oculis/\*\*/\*\.dm|g" <tools/ci/check_grep.sh | bash

echo -e "${BLUE}Re-running grep checks, but looking in modular_dredge...${NC}" # DREDGE EDIT ADDITION

# Run the linters again again, but modular Dredge code.
sed "s|code/\*\*/\*\.dm|modular_dredge/\*\*/\*\.dm|g" <tools/ci/check_grep.sh | bash # DREDGE EDIT ADDITION
