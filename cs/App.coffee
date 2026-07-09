import React, { useState } from 'react'
import { Box, Container, CssBaseline, ThemeProvider } from '@mui/material'

import theme from './theme.coffee'
import database from './database.coffee'
import wordScore from './score.coffee'
import packageJson from '../package.json'
import { COLOR, Footer, GameBoard, Header, NextGuess, NoSolutionMessage, SuccessMessage } from './components/index.coffee'

{ version } = packageJson

# Count occurrences of a letter in a word
occurrencesOf = (letter, word) ->
  count = 0
  count++ for c in word when c == letter
  count

# Return the word with the highest score
pick = (candidates) ->
  maxScore = Math.max ...(c.score for c in candidates)
  work = candidates.filter (entry) -> entry.score >= maxScore
  selection = Math.floor(Math.random() * work.length)
  work[selection].word

# Filter functions for candidate elimination
keepGreen = (candidates, letter, i) ->
  candidates.filter (entry) -> letter == entry.word[i]

keepYellow = (candidates, letter, i, minimum) ->
  candidates.filter (entry) ->
    letter != entry.word[i] and occurrencesOf(letter, entry.word) >= minimum

keepGray = (candidates, letter, i, maximum) ->
  candidates.filter (entry) ->
    letter != entry.word[i] and occurrencesOf(letter, entry.word) < maximum

App = ->
  [tries, setTries] = useState([])
  [candidates, setCandidates] = useState(database)
  [suggestion, setSuggestion] = useState(-> pick(database))
  [colors, setColors] = useState([])
  [found, setFound] = useState(false)
  [hardMode, setHardMode] = useState(false)

  handleNext = ->
    # Require all colors to be set (colors is sparse, so check every position)
    return unless [0...suggestion.length].every (i) -> colors[i]?

    newCandidates = [...candidates]
    isFound = true
    counts = {}

    # Handle correct letters (green)
    for i in [0...suggestion.length] when colors[i] == COLOR.CORRECT
      letter = suggestion[i]
      counts[letter] = if counts[letter]? then counts[letter] + 1 else 1
      newCandidates = keepGreen(newCandidates, letter, i)

    # Handle present letters (yellow)
    for i in [0...suggestion.length] when colors[i] == COLOR.PRESENT
      letter = suggestion[i]
      counts[letter] = if counts[letter]? then counts[letter] + 1 else 1
      newCandidates = keepYellow(newCandidates, letter, i, counts[letter])
      isFound = false

    # Handle absent letters (gray)
    for i in [0...suggestion.length] when colors[i] == COLOR.ABSENT
      letter = suggestion[i]
      counts[letter] = if counts[letter]? then counts[letter] + 1 else 1
      newCandidates = keepGray(newCandidates, letter, i, counts[letter])
      isFound = false

    # Update tries
    newTries = [...tries, { word: suggestion, colors }]

    # Compute next suggestion if not solved
    if isFound or newCandidates.length == 0
      newSuggestion = ''
    else
      # With <= 2 candidates left, guessing a candidate is at least as good as any probe word
      pool = if hardMode or newCandidates.length <= 2 then newCandidates else database
      scored = ({ word: entry.word, score: wordScore(entry.word, newCandidates) } for entry in pool)
      newSuggestion = pick(scored)

    # Update state
    setTries(newTries)
    setCandidates(newCandidates)
    setSuggestion(newSuggestion)
    setFound(isFound)
    setColors([])

  handleColor = (id, color) ->
    newColors = [...colors]
    newColors[id] = color
    setColors(newColors)

  handleHardModeChange = (enabled) ->
    setHardMode(enabled)

  <ThemeProvider theme={theme}>
    <CssBaseline />
    <Box
      sx={{
        minHeight: '100vh'
        backgroundColor: 'background.default'
        pb: 8
      }}
    >
      <Header title="WORDLE SOLVER" />

      <Container maxWidth="sm" sx={{ pt: 2 }}>
        <GameBoard tries={tries} />

        {if found
          <SuccessMessage attempts={tries.length} />
        else if candidates.length == 0
          <NoSolutionMessage />
        else
          <NextGuess
            word={suggestion}
            colors={colors}
            hardMode={hardMode}
            onNext={handleNext}
            onColor={handleColor}
          />
        }
      </Container>

      <Footer
        hardMode={hardMode}
        onHardModeChange={handleHardModeChange}
        version={version}
      />
    </Box>
  </ThemeProvider>

export default App
