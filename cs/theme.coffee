import { createTheme } from '@mui/material/styles'

theme = createTheme
  palette:
    mode: 'dark'
    primary:
      main: '#538d4e'
    secondary:
      main: '#b59f3b'
    background:
      default: '#121213'
      paper: '#1a1a1b'
    text:
      primary: '#ffffff'
      secondary: '#818384'
  typography:
    fontFamily: '"Clear Sans", "Helvetica Neue", Arial, sans-serif'
    h4:
      fontWeight: 700
    button:
      fontWeight: 700
  components:
    MuiButton:
      styleOverrides:
        root:
          borderRadius: 4
          textTransform: 'none'
    MuiRadio:
      styleOverrides:
        root:
          padding: 4

export default theme
