# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

- `pnpm dev` - Start dev server (port 3000)
- `pnpm build` - Production build to `/build`
- `pnpm preview` - Preview production build

## Stack

React 19 + Vite + CoffeeScript + Material-UI 7

## Architecture

**Entry:** `index.html` → `cs/index.coffee` → `App.coffee`

**Core Algorithm (App.coffee):**

- Tracks tries, candidates, suggestion, colors, hardMode state
- Three filter functions eliminate candidates: `keepGreen`, `keepYellow`, `keepGray`
- Handles multi-letter occurrences via counting
- Scoring in `cs/score.coffee` ranks words by letter overlap with remaining candidates

**Data:** `cs/database.coffee` contains ~450KB word list array

**Components:** `cs/components/` - functional React components using MUI `sx` prop for styling

**Theme:** `cs/theme.coffee` - MUI dark theme with Wordle colors (green=#538d4e, gold=#b59f3b)
