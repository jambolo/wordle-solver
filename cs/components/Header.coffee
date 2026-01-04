import React from 'react'
import { AppBar, Toolbar, Typography, Box } from '@mui/material'

Header = ({ title }) ->
  <AppBar position="static" elevation={0} sx={{ backgroundColor: 'transparent', borderBottom: '1px solid #3a3a3c' }}>
    <Toolbar sx={{ justifyContent: 'center' }}>
      <Typography variant="h5" component="h1" sx={{ fontWeight: 700, letterSpacing: '0.1em' }}>
        {title}
      </Typography>
    </Toolbar>
  </AppBar>

export default Header
