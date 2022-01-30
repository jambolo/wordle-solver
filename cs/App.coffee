`
import './App.css'
import database from './database'

import React, { Component } from 'react'
import { Grid } from '@mui/material';
import { Radio, RadioGroup } from '@mui/material';
import { FormControl, FormControlLabel } from '@mui/material';
import { Button } from '@mui/material';
`

ColoredLetter = (props) ->
  { letter, color } = props
  <Grid item xs={1}>
    <font size={7}> <span style={ { backgroundColor: color } }> {letter} </span> </font>
  </Grid>

Try = (props) ->
  { word, colors } = props
  <Grid container spacing={4}>
    { <ColoredLetter letter={word[i]} color={colors[i]} key={i}/> for i in [0...5] }
  </Grid>

ColorSelector = (props) ->
  { id, onChange } = props
  <FormControl>
    <RadioGroup onChange={(event) -> onChange(id, event.target.value)}>
      <FormControlLabel value="lightgray" control={<Radio />} label="gray" />
      <FormControlLabel value="yellow" control={<Radio />} label="yellow" />
      <FormControlLabel value="lightgreen" control={<Radio />} label="green" />
    </RadioGroup>
  </FormControl>

NextTry = (props) ->
  { word, onNext, onColor } = props
  <div className="NextTry">
    <Grid container spacing={4}>
      { <Grid item xs={1} key={i}> <font size={7}> {word[i]} </font> </Grid> for i in [0...5] }
    </Grid>
    <Grid container spacing={4}>
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
      suggestion: @pick(database)
      colors: []
      found: false
    return

  # Picks a word randomly among the ones with the highest score
  pick: (candidates) ->
    # Find the highest score
    maxScore = candidates[0].score
    for c in candidates
      maxScore = Math.max(c.score, maxScore)

    # Remove candidates with scores lower than the max
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
        when "lightgray"
          # Only keep words that don't have this letter
          candidates = @keepGray(candidates, letter)
          found = false # This is not the solution
        when "yellow"
          # Only keep words without this letter at this spot but somewhere else
          candidates = @keepYellow(candidates, letter, i)
          found = false # This is not the solution
        when "lightgreen"
          # Only keep words with this letter at this spot
          candidates = @keepGreen(candidates, letter, i)
        else
          console.error "Invalid color \"#{@state.colors[i]}\""

    # Update with the new list of candidates and pick one for the next suggestion
    tries = @state.tries.concat [{ word: @state.suggestion, colors: @state.colors }]
    suggestion = if found then "" else @pick(candidates)
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
      { <Try word={t.word} colors={t.colors} key={t.word}/> for t in @state.tries }
      { <NextTry word={@state.suggestion} onNext={@handleNext} onColor={@handleColor}/> if !@state.found }
    </div>


export default App
