import React from 'react'
import { Box, FormControlLabel, Switch, Typography, Stack } from '@mui/material'

Footer = ({ hardMode, onHardModeChange, version }) ->
  <Box
    component="footer"
    sx={{
      position: 'fixed'
      bottom: 0
      left: 0
      right: 0
      py: 1.5
      px: 2
      backgroundColor: 'background.default'
      borderTop: '1px solid #3a3a3c'
    }}
  >
    <Stack
      direction="row"
      justifyContent="space-between"
      alignItems="center"
      maxWidth={400}
      mx="auto"
    >
      <FormControlLabel
        control={
          <Switch
            checked={hardMode}
            onChange={(e) -> onHardModeChange(e.target.checked)}
            size="small"
            color="primary"
          />
        }
        label={
          <Typography variant="body2" color="text.secondary">
            Hard mode
          </Typography>
        }
      />
      <Typography variant="caption" color="text.secondary">
        v{version}
      </Typography>
    </Stack>
  </Box>

export default Footer
