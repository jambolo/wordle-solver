import React from 'react'
import { Typography, Paper } from '@mui/material'
import SearchOffIcon from '@mui/icons-material/SearchOff'

NoSolutionMessage = ->
  <Paper
    elevation={0}
    sx={{
      backgroundColor: 'background.paper'
      p: 3
      borderRadius: 2
      maxWidth: 300
      mx: 'auto'
      textAlign: 'center'
    }}
  >
    <SearchOffIcon sx={{ fontSize: 48, mb: 1 }} />
    <Typography variant="h6" sx={{ fontWeight: 700 }}>
      No words match
    </Typography>
    <Typography variant="body2" color="text.secondary">
      Check the colors entered for each guess
    </Typography>
  </Paper>

export default NoSolutionMessage
