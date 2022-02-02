`
import './App.css'
import database from './database'
import wordScore from './score'

import React, { Component } from 'react'
import { Grid } from '@mui/material';
import { Radio, RadioGroup } from '@mui/material';
import { FormControl, FormControlLabel } from '@mui/material';
import { Button } from '@mui/material';
import { Box } from '@mui/material';
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


prospectiveColorFor = (color) ->
  switch color
    when COLOR.ABSENT
      return COLOR.PROSPECTIVE_ABSENT
    when COLOR.PRESENT
      return COLOR.PROSPECTIVE_PRESENT
    when COLOR.CORRECT
      return COLOR.PROSPECTIVE_CORRECT
    else
      console.error "prospectiveColorFor: Invalid color \"#{color}\"" if color?
  return COLOR.BACKGROUND

ColoredLetter = (props) ->
  { letter, color } = props
  <Grid item xs={1}>
    <Box sx={{backgroundColor: color}}> <font size={7} color={COLOR.TEXT}><b>{letter.toUpperCase()}</b></font></Box>
  </Grid>

Try = (props) ->
  { word, colors } = props
  <Grid container spacing={1} style={{paddingTop: 8; paddingLeft: 8}}>
    { <ColoredLetter letter={word[i]} color={colors[i]} key={i}/> for i in [0...5] }
  </Grid>

Tries = (props) ->
  { tries } = props
  <div>
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
  { word, colors, onNext, onColor } = props
  <div>
    <Grid container spacing={1} style={{paddingTop: 8; paddingLeft: 8}}>
      {  <NextTryLetter key={i} letter={word[i]} color={prospectiveColorFor(colors[i])}/> for i in [0...5] }
    </Grid>
    <Grid container spacing={1}  alignItems="center" style={{paddingTop: 8; paddingLeft: 8}}>
      { <Grid item xs={1} key={i}><ColorSelector id={i} onChange={onColor}/></Grid> for i in [0...5] }
      <Grid item xs={1}> <Button variant="contained" onClick={onNext}>Next</Button> </Grid>
    </Grid>
  </div>

class App extends Component
  constructor: (props) ->
    super props
    @state =
      tries: []
      candidates: database
      suggestion: @pick(database, 0.1)
      colors: []
      found: false
    return

  # Picks a word randomly among the ones with the highest score
  pick: (candidates, range) ->
    # Find the highest score
    maxScore = candidates[0].score
    for c in candidates
      maxScore = Math.max(c.score, maxScore)

    # Keep only candidates with scores close to the max
    if range?
      work = candidates.filter( (entry) -> entry.score >= maxScore * (1.0 - range) )
    else
      work = candidates.filter( (entry) -> entry.score >= maxScore )

    # Select one at random
    selection = Math.floor(Math.random() * work.length)
    return work[selection].word

  # Keeps candidates that don't have the letter
  keepGray: (candidates, letter) ->
    candidates.filter (entry) -> not (letter in entry.word)

  # Keeps candidates without this letter at this spot but somewhere else
  keepYellow: (candidates, letter, i) ->
    candidates.filter (entry) -> letter != entry.word[i] and letter in entry.word

  # Keeps candidates with this letter at this spot
  keepGreen: (candidates, letter, i) ->
    candidates.filter (entry) -> letter == entry.word[i]

  # Handles the Next button
  handleNext: =>
    # If any of the colors are not set, then ignore this
    for c in @state.colors
      return if not c?

    # Eliminate candidates based on the response for each letter
    candidates = @state.candidates[..]
    found = true # initially assume the word is the solution (gray and yellow responses will set to false)

    for i in [0...5]
      letter = @state.suggestion[i]
      switch @state.colors[i]
        when COLOR.ABSENT
          # Only keep words that don't have this letter
          candidates = @keepGray(candidates, letter)
          found = false # This is not the solution
        when COLOR.PRESENT
          # Only keep words without this letter at this spot but somewhere else
          candidates = @keepYellow(candidates, letter, i)
          found = false # This is not the solution
        when COLOR.CORRECT
          # Only keep words with this letter at this spot
          candidates = @keepGreen(candidates, letter, i)
        else
          console.error "handleNext: Invalid color \"#{@state.colors[i]}\""

    # Update the list of tries
    tries = @state.tries.concat [{ word: @state.suggestion, colors: @state.colors }]

    # If not done, then compute new scores for remaining candidates and pick one
    if not found
      candidates[i].score = wordScore(candidates[i], candidates) for i in [0...candidates.length]
      suggestion = @pick(candidates)
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

  render: ->
    <div className="App">
      <Tries tries={@state.tries}/>
      { <NextTry word={@state.suggestion} colors={@state.colors} onNext={@handleNext} onColor={@handleColor}/> if !@state.found }
      <p style={{textAlign: "left"}}>Version: {version}</p>
    </div>


export default App
