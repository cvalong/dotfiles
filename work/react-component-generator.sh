#!/bin/bash
#
# work/react-utils.sh
# Lightweight React component generator for work projects

# =======================================
# Component Generator Function
# =======================================
function generate-component() {
  # Colors for output
  GREEN="\033[0;32m"
  BLUE="\033[0;34m"
  YELLOW="\033[1;33m"
  RED="\033[0;31m"
  RESET="\033[0m"

  # Check if component name was provided as argument
  if [ -n "$1" ]; then
    COMPONENT_NAME=$1
  else
    # Prompt for component name
    echo -e "${YELLOW}Enter component name (PascalCase):${RESET}"
    read COMPONENT_NAME
  fi

  # Validate component name format (PascalCase)
  if ! [[ $COMPONENT_NAME =~ ^[A-Z][a-zA-Z0-9]*$ ]]; then
    echo -e "${RED}Error: Component name must be in PascalCase${RESET}"
    echo -e "${RED}Example: Button, UserProfile, NavigationBar${RESET}"
    return 1
  fi

  # Component directory path (folder per component)
  COMPONENT_DIR="$COMPONENT_NAME"

  # Get current directory name for Storybook title
  CURRENT_DIR=$(basename "$PWD")

  # Create directory structure
  mkdir -p "$COMPONENT_DIR/__tests__"

  # Create Component.tsx
  cat > "$COMPONENT_DIR/$COMPONENT_NAME.tsx" << EOF
import * as React from 'react';

import { Styled$COMPONENT_NAME } from './$COMPONENT_NAME.styles';

export type Props = {
  /** Insert props */
};

export const $COMPONENT_NAME = (props: Props) => {
  return (
    <Styled$COMPONENT_NAME data-testid="$COMPONENT_NAME-test-id" {...props}>
      $COMPONENT_NAME
    </Styled$COMPONENT_NAME>
  );
};

export default $COMPONENT_NAME;
EOF

  # Create Component.stories.tsx
  cat > "$COMPONENT_DIR/$COMPONENT_NAME.stories.tsx" << EOF
import type { Meta, StoryObj } from '@storybook/react';

import { $COMPONENT_NAME } from './$COMPONENT_NAME';

const meta: Meta<typeof $COMPONENT_NAME> = {
  title: '$CURRENT_DIR/$COMPONENT_NAME',
  component: $COMPONENT_NAME,
};

export default meta;

type Story = StoryObj<typeof $COMPONENT_NAME>;

export const Default$COMPONENT_NAME: Story = {
  args: {
    // insert your props here
  },
};
EOF

  # Create Component.test.tsx
  cat > "$COMPONENT_DIR/__tests__/$COMPONENT_NAME.test.tsx" << EOF
import React from 'react';

import { render, screen } from '@plextrac/test/test-utils';

import { $COMPONENT_NAME } from '../$COMPONENT_NAME';

describe('$COMPONENT_NAME', () => {
  it('renders the default component', () => {
    const defaultProps = {};
    render(<$COMPONENT_NAME {...defaultProps} />);

    expect(screen.getByTestId('$COMPONENT_NAME-test-id')).toBeInTheDocument();
  });
});
EOF

  # Create Component.styles.tsx
  cat > "$COMPONENT_DIR/$COMPONENT_NAME.styles.tsx" << EOF
import styled from 'styled-components';

export const Styled$COMPONENT_NAME = styled.div\`\`;
EOF

  # Output success message
  echo -e "${GREEN}✓ Component '$COMPONENT_NAME' created successfully!${RESET}"
  echo -e "${BLUE}Location: $COMPONENT_DIR/${RESET}"
  
  # List created files for chaining
  find "$COMPONENT_DIR" -type f | sort
}

# =======================================
# Lightweight aliases
# =======================================
alias gc="generate-component"
alias gen-comp="generate-component"
