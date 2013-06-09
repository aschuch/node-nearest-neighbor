#
# Nearest Neighbour algorithm
#

# ///////////////////////////////////////////
# Similarity comparison
# ///////////////////////////////////////////

#
# Calculates similarity of two records (a,b)
# based on comparison fields
#
recordSimilarity = (a, b, fields) ->
  sum = 0
  i = 0
  unmatchedFields = {} # all fields whose similarity is not exactly 1.0

  while i < fields.length
    name = fields[i].name
    measure = fields[i].measure

    if ''+measure == ''+exports.comparisonMethods.number
      if typeof(fields[i].max) != 'undefined' && fields[i].max != null
        similarity = measure(a[name], b[name], fields[i].max)
      else
        console.warn "max number missing, falling back to max: 9007199254740992"
        similarity = measure(a[name], b[name], 9007199254740992) # see http://stackoverflow.com/a/307200/1000569
    else
      similarity = measure(a[name], b[name])

    if similarity < 1.0
      unmatchedFields[name] = similarity
      #console.log name + " | " + a[name] + " " + b[name] + " | " + similarity

    sum += similarity
    i++

  [sum/fields.length, unmatchedFields]


# ///////////////////////////////////////////
# Similarity functions
# ///////////////////////////////////////////

#
# Calculates the exact similarity of two words
# returns a percentage of similarity 0||1
#
exactSimilarity = (a, b) ->
  a == b ? 1 : 0

# //////////////////////////////////////


#
# Calculates the similarity of two words
# returns a percentage of similarity 0..1
#
wordSimilarity = (a, b) ->
  left = tokenize(a)
  right = tokenize(b)
  middle = intersect(left, right)
  (2 * middle.length) / (left.length + right.length)

# //////////////////////////////////////

#
# Calculates the similarity of an array of words
# returns a percentage of similarity 0..1
#
wordArraySimilarity = (a, b) ->
  if a.length == b.length
    i = 0
    similarity = 0

    while i < a.length
      similarity += wordSimilarity(a[i], b[i])
      i++
    return similarity/a.length
  0

# //////////////////////////////////////

#
# Calculates the similarity of two IP addresses
# returns a percentage of similarity 0..1
#
ipSimilarity = (a, b) ->
  left = a.split(".")
  right = b.split(".")
  diffs = []
  i = 0

  while i < 4
    diff1 = 255 - left[i]
    diff2 = 255 - right[i]
    diff = Math.abs(diff2 - diff1)
    diffs[i] = diff
    i++

  distance =  calculateSum(diffs) / (255 * 4)
  1 - distance

# //////////////////////////////////////

#
# Calculates the similarity of an array of IP addresses
# returns a percentage of similarity 0..1
#
ipArraySimilarity = (a, b) ->
  if a.length == b.length
    i = 0
    similarity = 0
    num = 0

    while i < a.length
      if a[i].match(/\b(?:\d{1,3}\.){3}\d{1,3}\b/) != null && b[i].match(/\b(?:\d{1,3}\.){3}\d{1,3}\b/) != null
        similarity += ipSimilarity(a[i], b[i])
        num++
      i++
    return similarity/num
  0

# //////////////////////////////////////

#
# Calculates the similarity of two numbers
# returns a percentage of similarity 0..1
#
numberSimilarity = (a, b, max) ->
  diff1 = max - a
  diff2 = max - b
  diff = Math.abs(diff2 - diff1)
  distance = diff / max
  1 - distance


# ///////////////////////////////////////////
# Helper methods
# ///////////////////////////////////////////

#
# Returns tokens in pairs of two
# from the given string
#
tokenize = (string) ->
  tokens = []

  if typeof(string) != 'undefined' && string != null
    i = 0
    while i < string.length - 1
      tokens.push string.substr(i, 2).toLowerCase()
      i++
  tokens.sort()

# //////////////////////////////////////

#
# Calculates the intersection of two
# given arrays of strings
#
intersect = (a, b) ->
  ai = 0
  bi = 0
  result = new Array()
  while ai < a.length and bi < b.length
    if a[ai] < b[bi]
      ai++
    else if a[ai] > b[bi]
      bi++
    else
      # they're equal
      result.push a[ai]
      ai++
      bi++
  result

# //////////////////////////////////////

#
# Calculates the sum of an array of values
#
calculateSum = (items) ->
  sum = 0
  i = 0

  while i < items.length
    sum += items[i]
    i++
  sum


# ///////////////////////////////////////////
# Public methods
# ///////////////////////////////////////////

#
#
#
exports.comparisonMethods =
  exact: exactSimilarity
  word: wordSimilarity
  wordArray: wordArraySimilarity
  ip: ipSimilarity
  ipArray: ipArraySimilarity
  number: numberSimilarity


#
# Calculates most similar record given a query object
# and multiple items that should be checked for similarity
# to the query object
#
exports.findMostSimilar = (query, items, fields, callback) ->
  maxSimilarity = 0
  result = null
  i = 0

  while i < items.length
    item = items[i]
    [similarity, unmatchedFields] = recordSimilarity(item, query, fields)

    if similarity > maxSimilarity
      maxSimilarity = similarity
      result = item
    i++

  callback result, maxSimilarity, unmatchedFields

