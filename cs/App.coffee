`
import './App.css'
import database from './database'
import wordScore from './score'

import React, { Component } from 'react'
import { Box, Button, FormControl, FormControlLabel, FormGroup, Grid, Radio, RadioGroup, Switch } from '@mui/material';
`
{ version } = require '../package.json'

# Normal colors
COLOR =
  PRESENT:              "#c9b458"
  CORRECT:              "#6aaa64"
  ABSENT:               "#787c7e"
  BACKGROUND:           "#ffffff"
  TEXT:                 "#ffffff"
  PROSPECTIVE_PRESENT:  "#e7dfb7"
  PROSPECTIVE_CORRECT:  "#c4ddc2"
  PROSPECTIVE_ABSENT:   "#ced0d1"

# # Dark theme colors
# COLOR =
#   PRESENT:    "#b59f3b"
#   CORRECT:    "#538d4e"
#   ABSENT:     "#3a3a3c"
#   BACKGROUND: "#121213"

# Counts the number of occurrences of a letter in a word
occurrencesOf = (letter, word) ->
  count = 0
  count++ for c in word when c == letter
  return count

prospectiveColorFor = (color) ->
  switch color
    when COLOR.ABSENT
      return COLOR.PROSPECTIVE_ABSENT
    when COLOR.PRESENT
      return COLOR.PROSPECTIVE_PRESENT
    when COLOR.CORRECT
      return COLOR.PROSPECTIVE_CORRECT
    else
      console.error 'prospectiveColorFor: Invalid color "#{color}"' if color?
  return COLOR.BACKGROUND

ColoredLetter = (props) ->
  { letter, color } = props
  boxStyle = { backgroundColor: color }
  <div className="letter-box filled-box" style={boxStyle}>
    {letter}
  </div>
#  <Grid item xs={1}>
#    <Box sx={{backgroundColor: color}}> <font size={7} color={COLOR.TEXT}><b>{letter.toUpperCase()}</b></font></Box>
#  </Grid>

Try = (props) ->
  { word, colors } = props
  <div  className="letter-row">
    { <ColoredLetter letter={word[i]} color={colors[i]} key={i}/> for i in [0...5] }
  </div>
#  <Grid container spacing={1} style={{paddingTop: 8; paddingLeft: 8}}>
#    { <ColoredLetter letter={word[i]} color={colors[i]} key={i}/> for i in [0...5] }
#  </Grid>

Tries = (props) ->
  { tries } = props
  <div className="game-board" >
    { <Try word={t.word} colors={t.colors} key={t.word}/> for t in tries }
  </div>

NextTryLetter = (props) ->
  {letter, color} = props
  <Grid item xs={1}>
    <Box sx={{border: "2px solid lightgray"; backgroundColor: color}}><font size={7}><b> {letter.toUpperCase()} </b></font> </Box>
  </Grid>

ColorSelector = (props) ->
  { id, onChange } = props
  <FormControl>
    <RadioGroup onChange={(event) -> onChange(id, event.target.value)}>
      <FormControlLabel value={COLOR.ABSENT} control={<Radio />} label="gray" />
      <FormControlLabel value={COLOR.PRESENT} control={<Radio />} label="yellow" />
      <FormControlLabel value={COLOR.CORRECT} control={<Radio />} label="green" />
    </RadioGroup>
  </FormControl>

NextTry = (props) ->
  { word, colors, hard, onNext, onColor } = props
  <>
    <Grid container spacing={1} style={{paddingTop: 8; paddingLeft: 8}}>
      { <NextTryLetter key={i} letter={word[i]} color={if hard then prospectiveColorFor(colors[i]) else COLOR.BACKGROUND}/> for i in [0...5] }
    </Grid>
    <Grid container spacing={1}  alignItems="center" style={{paddingTop: 8; paddingLeft: 8}}>
      { <Grid item xs={1} key={i}><ColorSelector id={i} onChange={onColor}/></Grid> for i in [0...5] }
      <Grid item xs={1}> <Button variant="contained" onClick={onNext}>Next</Button> </Grid>
    </Grid>
  </>

HardMode = (props) ->
  { checked, onChange } = props
  <FormGroup>
    <FormControlLabel control={<Switch checked={checked} onChange={(event) -> onChange(event.target.checked)}/>} label="Hard mode" />
  </FormGroup>

BottomBar = (props) ->
  { hardMode, onHardMode, version } = props
  <Grid container>
    <Grid item xs={3}><HardMode checked={hardMode} onChange={onHardMode}/></Grid>
    <Grid item xs={3}><p style={{textAlign: "left"}}>Version: {version}</p></Grid>
  </Grid>

class App extends Component
  constructor: (props) ->
    super props
    @state =
      tries: []
      candidates: database
      suggestion: @pick(database, 0.1)
      colors: []
      found: false
      hard: false
    return

  # Return the word with the highest score
  pick: (candidates) ->
    # Find the highest score
    maxScore = candidates[0].score
    maxScore = Math.max(c.score, maxScore) for c in candidates

    # Keep only candidates with scores equal to the max
    work = candidates.filter( (entry) -> entry.score >= maxScore )

    # Select one at random
    selection = Math.floor(Math.random() * work.length)
    return work[selection].word

  # Returns all candidates with this letter at this spot
  keepGreen: (candidates, letter, i) ->
    candidates.filter (entry) -> letter == entry.word[i]

  # Returns all candidates with this letter occuring a minimum number of times at a different spot
  keepYellow: (candidates, letter, i, minimum) ->
    candidates.filter((entry) -> letter != entry.word[i] and occurrencesOf(letter, entry.word) >= minimum)

  # Returns all candidates with fewer occurrences of the letter with none at this spot
  keepGray: (candidates, letter, i, maximum) ->
    candidates.filter (entry) -> letter != entry.word[i] and occurrencesOf(letter, entry.word) < maximum

  # Handles the Next button
  handleNext: =>
    # If any of the colors are not set, then ignore this
    for c in @state.colors
      return if not c?

    # Eliminate candidates based on the response for each letter. The order of checking is important in order to
    # correctly handle multiple characters.

    candidates = @state.candidates[..]
    found = true # initially assume the word is the solution (gray and yellow responses will set to false)
    counts = {}

    # Handle correct letters (COLOR.CORRECT)
    for i in [0...@state.suggestion.length] when @state.colors[i] == COLOR.CORRECT
      letter = @state.suggestion[i]
      counts[letter] = if counts[letter]? then counts[letter] + 1 else 1
      candidates = @keepGreen(candidates, letter, i)

    # Handle present letters (COLOR.PRESENT)
    for i in [0...@state.suggestion.length] when @state.colors[i] == COLOR.PRESENT
      letter = @state.suggestion[i]
      counts[letter] = if counts[letter]? then counts[letter] + 1 else 1
      candidates = @keepYellow(candidates, letter, i, counts[letter])
      found = false # This is not the solution

    # Handle absent letters (COLOR.ABSENT)
    for i in [0...@state.suggestion.length] when @state.colors[i] == COLOR.ABSENT
      letter = @state.suggestion[i]
      counts[letter] = if counts[letter]? then counts[letter] + 1 else 1
      candidates = @keepGray(candidates, letter, i, counts[letter])
      found = false # This is not the solution

    # Update the list of tries
    tries = @state.tries.concat [{ word: @state.suggestion, colors: @state.colors }]

    # If not done, then compute new scores for remaining candidates and pick one
    if not found
      if @state.hard
        candidates[i].score = wordScore(candidates[i].word, candidates) for i in [0...candidates.length]
        suggestion = @pick(candidates)
      else
        database[i].score = wordScore(database[i].word, candidates) for i in [0...database.length]
        suggestion = @pick(database)
    else
      suggestion = ""

    # Update with the new list of candidates and pick one for the next suggestion
    @setState {
      tries
      candidates
      suggestion
      found
    }
    return

  # Handles color radio buttons
  handleColor: (id, color) =>
    colors = @state.colors[..]
    colors[id] = color
    @setState { colors }
    return

  # Handles the hardmode switch
  handleHardMode: (hard) =>
    @setState { hard }
    return

  render: ->
    <div className="App">
      <Tries tries={@state.tries}/>
      { <NextTry word={@state.suggestion} colors={@state.colors} hard={@state.hard} onNext={@handleNext} onColor={@handleColor}/> if !@state.found }
      <BottomBar hardMode={@state.hard} onHardMode={@handleHardMode} version={version} />
    </div>


export default App
