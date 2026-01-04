import React from 'react'
import { Box, FormControl, Radio, RadioGroup, FormControlLabel, Stack } from '@mui/material'

COLOR =
  PRESENT: '#c9b458'
  CORRECT: '#6aaa64'
  ABSENT: '#787c7e'

ColorDot = ({ color }) ->
  <Box
    sx={{
      width: 16
      height: 16
      borderRadius: '50%'
      backgroundColor: color
      border: '1px solid rgba(255,255,255,0.3)'
    }}
  />

ColorSelector = ({ id, value, onChange }) ->
  <FormControl size="small">
    <RadioGroup
      value={value or ''}
      onChange={(event) -> onChange(id, event.target.value)}
    >
      <Stack spacing={0}>
        <FormControlLabel
          value={COLOR.ABSENT}
          control={<Radio size="small" />}
          label={<ColorDot color={COLOR.ABSENT} />}
          sx={{ m: 0, '& .MuiFormControlLabel-label': { ml: 0.5 } }}
        />
        <FormControlLabel
          value={COLOR.PRESENT}
          control={<Radio size="small" />}
          label={<ColorDot color={COLOR.PRESENT} />}
          sx={{ m: 0, '& .MuiFormControlLabel-label': { ml: 0.5 } }}
        />
        <FormControlLabel
          value={COLOR.CORRECT}
          control={<Radio size="small" />}
          label={<ColorDot color={COLOR.CORRECT} />}
          sx={{ m: 0, '& .MuiFormControlLabel-label': { ml: 0.5 } }}
        />
      </Stack>
    </RadioGroup>
  </FormControl>

export { COLOR }
export default ColorSelector
