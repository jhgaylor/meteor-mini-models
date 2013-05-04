Package.describe({
  summary: "Simple models for meteor"
});

Package.on_use(function (api, where) {
  api.use("underscore", ['client', 'server']);
  api.add_files('lib/mini-models.js', ['client', 'server']);
});

Package.on_test(function (api) {
  
});