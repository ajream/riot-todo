<todo>
  <section class="todoapp">
    <header class="header">
      <h1>Todos</h1>
      <input class="new-todo" autocomplete="off" placeholder="What needs to be done?" onkeyup={ addTodo } autofocus>
    </header>
    <section class="main" show={ todos.length }>
      <input class="toggle-all" type="checkbox" checked={ allDone } onclick={ toggleAll }>
      <ul class="todo-list">
        <todo-list each={ t, i in filteredTodos() } data={ t } parentview={ parent }></todo-list>
      </ul>
    </section>
    <footer class="footer" show={ todos.length }>
      <span class="todo-count">
        <strong>{ remaining }</strong> { remaining == 1 ? 'item' : 'items' } left
      </span>
      <ul class="filters">
        <li><a class={ selected: activeFilter=='all' } href="#/all">All</a></li>
        <li><a class={ selected: activeFilter=='active' } href="#/active">Active</a></li>
        <li><a class={ selected: activeFilter=='completed' } href="#/completed">Completed</a></li>
      </ul>
      <button class="clear-completed" onclick={ removeCompleted } show={ todos.length > remaining }>
        Clear completed ({ todos.length - remaining })
      </button>
    </footer>
  </section>

  <script>
    var self = this;
    self.todos = opts.data || [];

    riot.route.exec(function(base, filter) {
      self.activeFilter = filter || 'all';
    })

    // 监听是否有任务更新
    self.on('update', function() {
      self.remaining = self.todos.filter(function(t) { return !t.completed}).length;
      self.allDone = self.remaining == 0;
      self.saveTodos();
    })

    saveTodos() {
      todoStorage.save(self.todos);
      self.update();
    }

    filteredTodos() {
      if (self.activeFilter == 'active') {
        var filter_todos = self.todos.filter(function(element) {
          return !element.completed;
        })
        return filter_todos;
      } else if (self.activeFilter == 'completed') {
        var filter_todos =  self.todos.filter(function(element) {
          return element.completed;
        })
        return filter_todos;
      } else {
        return self.todos;
      }
    }

    addTodo(e) {
      if (e.which == 13) {
        var value = e.target.value && e.target.value.trim();
        if (!value) {
          return;
        }
        self.todos.push({ title: value, completed: false });
        e.target.value = '';
      }
    }

    removeTodo(todo) {
      self.todos.some(function (t) {
        if (todo === t) {
          self.todos.splice(self.todos.indexOf(t), 1);
        }
      })
      self.update();
    }

    toggleAll(e) {
      self.todos.forEach(function (t) {
        t.completed = e.target.checked;
      })
      return true;
    }

    removeCompleted(e) {
      self.todos = self.todos.filter(function(t) {
        return !t.completed;
      })
    }

    riot.route(function(base, filter) {
      self.activeFilter = filter;
      self.update();
    })
  </script>
</todo>