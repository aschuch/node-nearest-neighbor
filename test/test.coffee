nn = require('../src/nearest-neighbor')
should = require('should')

# ///////////////////////////////

items = [
  name: "Bill"
  age: 10
  pc: "Mac"
  ip: "68.23.13.8"
,
  name: "Alice"
  age: 22
  pc: "Windows"
  ip: "193.186.11.3"
,
  name: "Bob"
  age: 12
  pc: "Windows"
  ip: "56.89.22.1"
]

query =
  name: "Bob"
  age: 12
  pc: "Windows"
  ip: "68.23.13.10"

nn.comparisonMethods.custom = (a, b) ->
  return 0.5

fields = [
    name: "name"
    measure: nn.comparisonMethods.word
  ,
    name: "age"
    measure: nn.comparisonMethods.number
    max: 100
  ,
    name: "pc"
    measure: nn.comparisonMethods.word
  ,
    name: "ip"
    measure: nn.comparisonMethods.ip
  ]

nn.findMostSimilar query, items, fields, (nearestNeighbor, probability, unmatchedFields) ->
  console.log query
  console.log nearestNeighbor
  console.log probability
  console.log unmatchedFields

console.log "====================="

query =
  name: "Bob"
  age: 12
  pc: "Windows"
  ip: "56.89.22.1"

nn.findMostSimilar query, items, fields, (nearestNeighbor, probability, unmatchedFields) ->
  console.log query
  console.log nearestNeighbor
  console.log probability
  console.log unmatchedFields

console.log "====================="

query =
  name: "Max"
  age: 14
  pc: "Windows XP"
  ip: "56.89.22.1"

nn.findMostSimilar query, items, fields, (nearestNeighbor, probability, unmatchedFields) ->
  console.log query
  console.log nearestNeighbor
  console.log probability
  console.log unmatchedFields

console.log "====================="

# //////////////////////////////////////

console.log "\nAll tests OK"
