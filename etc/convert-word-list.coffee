#convert-word-list
#
# Converts the word list from https://github.com/tabatkins/wordle-list to a database
#

fs = require "fs"

inputFileName = process.argv[2]
outputFileName = process.argv[3]

# Read word list a line at a time
lines = (line for line in fs.readFileSync(inputFileName, { encoding: 'utf-8' }).split(/\r|\n/) when line.length > 0)

# Process each line and add to the database
db = []
for word in lines
  if word.length == 5

    # Compute the word's score. The score is the number of different letters. Choosing words without repeated letters
    # will eliminate candidates more quickly.
    letterCounts = {}
    for c in word
      if letterCounts[c]?
        letterCounts[c]++
      else
        letterCounts[c] = 1
    score = 0
    score++ for value of letterCounts

    # Add to the db
    db.push { word, score }
  else
    console.log "Invalid word \"#{word}\""

# Sort the db alphabetically
db.sort (a, b) -> if a.word >= b.word then 1 else -1

# Write the database to a string
output = "database = [\n"
for entry in db[0...-1]
  output += "  { word: \"#{entry.word}\", score: #{entry.score} },\n"
output += "  { word: \"#{db[db.length-1].word}\", score: #{db[db.length-1].score} }\n"
output += "]\n\nexport default database\n"

# Write the database to a file
fs.writeFileSync outputFileName, output
