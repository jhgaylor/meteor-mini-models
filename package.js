Package.describe({
  summary: "Simple models for meteor"
});

Package.on_use(function (api, where) {
  api.add_files('lib/mini-models.js', ['client', 'server']);
});

Package.on_test(function (api) {
  
});