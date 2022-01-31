# Functions for scoring words
#

# Compute the word's score based on the candidates remaining. Higher is better.
#
# The score is a measure of the word's similarity to all other candidates (other than itself). The idea is that
# information gained from the word can be applied more of the other candidates.

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

export default wordScore
