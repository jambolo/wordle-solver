import React from 'react'
import { Box, Button, Paper, Stack, Typography } from '@mui/material'
import ColoredLetter from './ColoredLetter.coffee'
import ColorSelector, { COLOR } from './ColorSelector.coffee'

PROSPECTIVE_COLOR =
  "#{COLOR.ABSENT}": '#3a3a3c'
  "#{COLOR.PRESENT}": '#b59f3b'
  "#{COLOR.CORRECT}": '#538d4e'

getProspectiveColor = (color) ->
  PROSPECTIVE_COLOR[color] or '#121213'

NextGuess = ({ word, colors, hardMode, onNext, onColor }) ->
  <Paper
    elevation={0}
    sx={{
      backgroundColor: 'background.paper'
      p: 2
      borderRadius: 2
      maxWidth: 400
      mx: 'auto'
    }}
  >
    <Typography variant="subtitle2" color="text.secondary" sx={{ mb: 1, textAlign: 'center' }}>
      Suggested word
    </Typography>

    <Stack direction="row" justifyContent="center" sx={{ mb: 2 }}>
      {[0, 1, 2, 3, 4].map (i) ->
        bgColor = if hardMode then getProspectiveColor(colors[i]) else '#121213'
        <ColoredLetter key={i} letter={word[i]} color={bgColor} />
      }
    </Stack>

    <Stack direction="row" justifyContent="center" spacing={2} sx={{ mb: 2 }}>
      {[0, 1, 2, 3, 4].map (i) ->
        <Box key={i} sx={{ display: 'flex', justifyContent: 'center', width: 58 }}>
          <ColorSelector id={i} value={colors[i]} onChange={onColor} />
        </Box>
      }
    </Stack>

    <Box sx={{ display: 'flex', justifyContent: 'center' }}>
      <Button
        variant="contained"
        color="primary"
        size="large"
        onClick={onNext}
        sx={{ px: 4 }}
      >
        Submit
      </Button>
    </Box>
  </Paper>

export default NextGuess
