Package.describe({
  summary: "Simple models for meteor."
});

Package.on_use(function (api, where) {
  api.use(["underscore", "coffeescript"], ['client', 'server']);
  api.add_files('lib/mini-models.coffee', ['client', 'server']);
});

Package.on_test(function (api) {
  api.use(['mini-models', 'tinytest'], ['client', 'server']);
  api.add_files('tests/mini-models_tests.coffee', 'client');
});