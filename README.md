# Wordle Solver

## The Rules

Wordle gives you six tries to guess a secret five-letter word. After each guess, every letter is colored: **green** means the letter is correct and in the right position, **yellow** means the letter is in the word but in a different position, and **gray** means the letter is not in the word (or appears fewer times than guessed). In hard mode, every guess must use all revealed hints.

## The Algorithm

The solver starts with a database of five-letter words as the candidate pool and suggests a word each turn. After you enter the colors Wordle returned, it eliminates candidates:

- **Green** — keep only words with that letter in that exact position.
- **Yellow** — keep only words that contain the letter (at least as many times as it has been marked green or yellow so far) but not in that position.
- **Gray** — keep only words with fewer occurrences of that letter, which handles repeated letters correctly.

It then scores potential guesses by how much they resemble the remaining candidates: a word earns **4 points** for each letter that matches a candidate exactly by position and **1 point** for each distinct letter that appears anywhere in a candidate, summed over all candidates. A candidate word also scores against itself, giving a small built-in bonus so that in the endgame a word that could actually be the answer beats a mere probe word.

The word with the highest total score becomes the next suggestion, with ties broken at random. Normally any word in the database can be suggested — even an eliminated one, if it reveals more information — but in hard mode, or when two or fewer candidates remain, the suggestion is drawn from the remaining candidates only.

## Building

The application is built with React, Vite, CoffeeScript, and Material-UI, and uses [pnpm](https://pnpm.io/) as its package manager.

```sh
pnpm install   # install dependencies
pnpm dev       # start the dev server on port 3000
pnpm build     # create a production build in /build
pnpm preview   # preview the production build
```

## Building the Database

The word database in `cs/database.json` is generated from the word list at
[tabatkins/wordle-list](https://github.com/tabatkins/wordle-list) by the script
`etc/convert-word-list.coffee`. The script reads a text file with one five-letter word
per line, precomputes each word's initial score against the full list, and writes the
result as a JSON file:

```sh
coffee etc/convert-word-list.coffee words cs/database.json
```

The `coffee` command comes from the [CoffeeScript](https://coffeescript.org/) package
(`pnpm add -g coffeescript` if you don't have it). The script also prints statistics,
including the highest-scoring words and the score distribution.
