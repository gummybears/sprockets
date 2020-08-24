// Plain old Javascript object
function Errors(errors){
  this.errors = errors;
}

Errors.prototype.get = function(field) {
  if( this.errors && this.errors[field] ){
     return this.errors[field];
  }

  return '';
}

Errors.prototype.hasError = function(field) {
  if( this.errors && this.errors[field] ){
    if( this.errors[field].length > 0 ){
      return true;
    }
  }
  return false;
}

Errors.prototype.clear = function(field) {
  if( this.errors && this.errors[field] ){
    delete this.errors[field];
  }
}

Errors.prototype.any = function() {
  if( this.errors ){
    return Object.keys(this.errors).length > 0;
  }

  return false;
}
