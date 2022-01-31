#convert-word-list
#
# Converts the word list from https://github.com/tabatkins/wordle-list to a database
#

fs = require "fs"

wordScore = (word, candidates) ->
  score = 0

  # Get a list of different letters in word
  letters = []
  letters.push letter for letter in word when not letter in letters

  # Compare the word to each of the candidates
  for e in candidates when e.word isnt word
    # 4 points for each letter in the word that matches exactly
    score += 4 for i in [0...5] when word[i] == e.word[i]

    # 1 point for each different letters that are in the word
    score += 1 for letter in letters when letter in e.word    # 1 point if the letter is in the word

  return score

inputFileName = process.argv[2]
outputFileName = process.argv[3]

# Read word list a line at a time
lines = (line for line in fs.readFileSync(inputFileName, { encoding: 'utf-8' }).split(/\r|\n/) when line.length > 0)

console.log "#{lines.length} lines read from \"#{inputFileName}\"."

# Process each line and add to the database
db = []
for word in lines
  if word.length == 5
    db.push { word, score: 0 }
  else
    console.log "Invalid word \"#{word}\""

console.log "#{db.length} words added to the database."

# Sort the db alphabetically for no good reason
db.sort (a, b) -> if a.word >= b.word then 1 else -1

console.log "Sorted."

# Score the words
for i in [0...db.length]
  db[i].score = wordScore(db[i].word, db)

console.log "#{db.length} words scored."

# Write the database to a string
output = "database = [\n"
for entry in db[0...-1]
  output += "  { word: \"#{entry.word}\", score: #{entry.score} },\n"
output += "  { word: \"#{db[db.length-1].word}\", score: #{db[db.length-1].score} }\n"
output += "]\n\nexport default database\n"

# Write the database to a file
fs.writeFileSync outputFileName, output

console.log "Database written to \"#{outputFileName}\"."

# Log statistics

maxScore = db[0].score
maxWords = [db[0].word]
for e in db
  if e.score > maxScore
    maxScore = e.score
    maxWords = [e.word]
  else if e.score == maxScore
    maxWords.push e.word

console.log "Words with the highest score of #{maxScore} are #{JSON.stringify(maxWords)}."

distribution = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
bucketWidth = (maxScore + 1) / 10.0
for e in db
  bucket = Math.floor(e.score / bucketWidth)
  distribution[bucket] += 1

console.log "Score distribution:"
for i in [0...distribution.length]
  paddedRangeMin = Math.floor(i * bucketWidth).toString().padStart(5, " ")
  paddedRangeMax = Number(Math.floor((i + 1) * bucketWidth) - 1).toString().padStart(5, " ")
  paddedDistribution = distribution[i].toString().padStart(5, " ")
  paddedPercent = Number(distribution[i] / db.length * 100).toFixed(1)
  console.log "#{paddedRangeMin} - #{paddedRangeMax}: #{paddedDistribution} (#{paddedPercent}%)"

console.log "Done."
