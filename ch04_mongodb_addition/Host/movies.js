// Data structures for Movie object
var mongoose = require('mongoose');
// Definition of the movie schema
var movieSchema = mongoose.Schema({
  name: String,
  director: String,
  release: Number
});
// Prepare object for export
var Movie = mongoose.model('Movie', movieSchema);
// Export the object for further usage.
module.exports = Movie;