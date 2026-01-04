import React from 'react'
import { Box, Typography, Paper } from '@mui/material'
import CheckCircleIcon from '@mui/icons-material/CheckCircle'

SuccessMessage = ({ attempts }) ->
  <Paper
    elevation={0}
    sx={{
      backgroundColor: 'primary.main'
      p: 3
      borderRadius: 2
      maxWidth: 300
      mx: 'auto'
      textAlign: 'center'
    }}
  >
    <CheckCircleIcon sx={{ fontSize: 48, mb: 1 }} />
    <Typography variant="h6" sx={{ fontWeight: 700 }}>
      Solved!
    </Typography>
    <Typography variant="body2">
      {attempts} {if attempts == 1 then 'attempt' else 'attempts'}
    </Typography>
  </Paper>

export default SuccessMessage
