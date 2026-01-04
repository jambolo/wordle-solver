import React from 'react'
import { Box, Typography } from '@mui/material'

ColoredLetter = ({ letter, color, size = 'normal' }) ->
  boxSize = if size == 'small' then 48 else 58
  fontSize = if size == 'small' then '1.5rem' else '2rem'

  <Box
    sx={{
      width: boxSize
      height: boxSize
      display: 'flex'
      justifyContent: 'center'
      alignItems: 'center'
      backgroundColor: color
      border: '2px solid'
      borderColor: if color == '#121213' then '#3a3a3c' else color
      borderRadius: '4px'
      m: 0.25
    }}
  >
    <Typography
      sx={{
        fontSize: fontSize
        fontWeight: 700
        color: '#ffffff'
        textTransform: 'uppercase'
        lineHeight: 1
      }}
    >
      {letter}
    </Typography>
  </Box>

export default ColoredLetter
