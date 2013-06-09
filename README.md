# Node Nearest Neighbor

[Nearest neighbor](http://en.wikipedia.org/wiki/K-nearest_neighbor_algorithm) algorithm to find the most similar object within an array of objects.


## Installation

```bash
$ npm install nearest-neighbor
```

## Usage

```javascript
var nn = require('nearest-neighbor');
nn.findMostSimilar(query, items, fields, function(nearestNeighbor, probability) {
  console.log(nearestNeighbor);
  console.log(probability);
});
```

```items``` is an array of objects that acts as the haystack that should be searched for the most similar ```query``` object. The ```fields``` array includes all the keys of the object the similarity should be calculated of and a comparison method to perform the similarity check. The callback returns the most similar object from the ```items``` array and the probability of the match between 1 and 0.

### Example

```javascript
nn = require('nearest-neighbor');

var items = [
  { name: "Bill", age: 10, pc: "Mac", ip: "68.23.13.8" },
  { name: "Alice", age: 22, pc: "Windows", ip: "193.186.11.3" },
  { name: "Bob", age: 12, pc: "Windows", ip: "56.89.22.1" }
];

var query = { name: "Bob", age: 12, pc: "Windows", ip: "68.23.13.10" };

var fields = [
  { name: "name", measure: nn.comparisonMethods.word },
  { name: "age", measure: nn.comparisonMethods.number, max: 100 },
  { name: "pc", measure: nn.comparisonMethods.word }, 
  { name: "ip", measure: nn.comparisonMethods.ip }
];

nn.findMostSimilar(query, items, fields, function(nearestNeighbor, probability) {
  console.log(query);
  console.log(nearestNeighbor);
  console.log(probability);
});
```

#### Output

The most similar object from the ```items``` array compared to the ```query``` object and the probability ([0..1]) of the match found.

```javascript
{ name: 'Bob', age: 12, pc: 'Windows', ip: '68.23.13.10' }
{ name: 'Bob', age: 12, pc: 'Windows', ip: '56.89.22.1' }
0.9764705882352941
```

### Comparison Methods

There are some basic comparison methods shipped with this module. Every comparison method has two parameters and returns a number between 1 and 0.
a is the current item from the ```items``` array
b is always the ```query``` object

```javascript
// example comparison function
function(a, b) {
  return 0.5;
};
```

The predefined comparison functions are available through the ```nn.comparisonMethods``` object. E.g. ```nn.comparisonMethods.exact```. 

* **exact**: Checks if a and b have the exact same value (using ```===```).
* **word**: Calculates the similarity of two words.
* **wordArray**: Calculates the similarity of an array of words.
* **ip**: Calculates the similarity of two IP addresses.
* **ipArray**: Calculates the similarity of an array of IP addresses.
* **number**: Calculates the similarity two numbers.


### Add your custom comparison method

You can also roll your own comparison method if you like.
Just add your custom method to the ```nn.comparisonMethods``` object.

```javascript
// define items and query as shown before

nn.comparisonMethods.custom = function(a, b) {
	// compare something...
	var value = ...
  	return value; // between 0 and 1
};

// then use your custom method for one of the comparison fields
var fields = [
  { name: "name", measure: nn.comparisonMethods.custom },
  { name: "age", measure: nn.comparisonMethods.number, max: 100 },
  { name: "pc", measure: nn.comparisonMethods.word }, 
  { name: "ip", measure: nn.comparisonMethods.ip }
];

// use nn.findMostSimilar as shown before
```

## Tests

```bash
$ npm test

{ name: 'Bob', age: 12, pc: 'Windows', ip: '68.23.13.10' }
{ name: 'Bob', age: 12, pc: 'Windows', ip: '56.89.22.1' }
0.9764705882352941

All tests OK
```

## Contributors

Thanks to [Blago](http://stackoverflow.com/users/113999/blago) on StackOverflow for providing the initial draft/idea for the algorithm.

## Contributing

* Create something awesome, make the code better, add some functionality,
  whatever (this is the hardest part).
* [Fork it](http://help.github.com/forking/)
* Create new branch to make your changes
* Commit all your changes to your branch
* Submit a [pull request](http://help.github.com/pull-requests/)

## Contact

Feel free to get in touch.

* Website: <http://schuch.me> 
* Twitter: [@schuchalexander](http://twitter.com/schuchalexander)

## Licence

Copyright (C) 2013 Alexander Schuch

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.