(function () {

  'use strict';

  riot.mount('todo', { data: todoStorage.fetch() });
  riot.mount('todo-footer');
}());