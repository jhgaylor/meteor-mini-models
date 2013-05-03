this.MiniModel = (function() {

  function MiniModel(doc, collectionName) {
    _.extend(this, doc, {
      _collectionName: collectionName
    });
  }

  MiniModel.prototype.collection = function() {
    this._collection || (this._collection = eval(this._collectionName));
    return this._collection;
  };

  MiniModel.prototype.save = function() {
    var data;
    data = _.extend({}, this);
    if (data._id) {
      delete data._id;
      return this.collection().update(this._id, data);
    } else {
      return this.collection().insert(data);
    }
  };

  MiniModel.prototype["delete"] = function() {
    return this.collection().remove(this._id);
  };

  return MiniModel;

})();
