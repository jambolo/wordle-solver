# Functions for scoring words
#

lettersIn = (word) ->
  letters = []
  letters.push letter for letter in word when letter not in letters
  return letters

# Compute the word's score based on the candidates remaining. Higher is better.
#
# The score is a measure of the word's similarity to all candidates. The idea is that information gained from
# the word can be applied to more of the other candidates. A word that is itself still a candidate is compared
# with itself too — that self-comparison is a deliberate bonus (~25 points) so that in the endgame a word that
# can actually be the answer beats a probe word that merely resembles the remaining candidates.

wordScore = (word, candidates) ->
  score = 0

  # Get a list of different letters in word
  letters = lettersIn(word)

  # Compare the word to each of the candidates
  for e in candidates
    # 4 points for each letter in the word that matches exactly
    score += 4 for i in [0...word.length] when word[i] == e.word[i]

    # 1 point for each different letters that are in the word
    score += 1 for letter in letters when letter in e.word    # 1 point if the letter is in the word

  return score

export default wordScore
