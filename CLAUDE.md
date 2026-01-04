# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## General Instructions for Claude

### Token Discipline

- Be concise by default.
- No explanations unless explicitly requested.
- No restating the question.
- No summaries at the end.
- Use bullet points only when clarity improves.
- Prefer short sentences.
- Assume reader is expert.

### Output Rules

- Answer the question directly.
- Do not add context, background, or alternatives unless asked.
- If uncertain, say "unknown" or ask one clarifying question.

### Code

- Output code only, no commentary.
- Prefer minimal, idiomatic solutions.
- Limit comments to very brief descriptions of what the code does. Do not describe why changes were made.

### Interaction

- Ask at most one clarifying question.
- Never suggest next steps unless requested.

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
