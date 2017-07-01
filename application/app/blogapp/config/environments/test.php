<?php
use Josegonzalez\Environments\Environment;

Environment::configure('test', false, [
  'Datasources.default.host'=> 'localhost',
  'Datasources.default.username'=> 'webapp',
  'Datasources.default.password'=> 'password',
  'Datasources.default.database'=> 'test_blog',
  'Datasources.test.host'=> 'localhost',
  'Datasources.test.username'=> 'webapp',
  'Datasources.test.password'=> 'password',
  'Datasources.test.database'=> 'test_blog',
]);
