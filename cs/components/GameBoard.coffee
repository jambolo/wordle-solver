import React from 'react'
import { Box, Stack } from '@mui/material'
import ColoredLetter from './ColoredLetter.coffee'

LetterRow = ({ word, colors }) ->
  <Stack direction="row" justifyContent="center">
    {[0, 1, 2, 3, 4].map (i) ->
      <ColoredLetter letter={word[i]} color={colors[i]} key={i} />
    }
  </Stack>

GameBoard = ({ tries }) ->
  <Box sx={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 0.5, py: 2 }}>
    {tries.map (t) ->
      <LetterRow word={t.word} colors={t.colors} key={t.word} />
    }
  </Box>

export default GameBoard
