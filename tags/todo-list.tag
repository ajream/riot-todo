<todo-list>
  <li class="todo {completed: todo.completed, editing: editing}">
    <div class="view">
      <input class="toggle" type="checkbox" checked={ todo.completed } onclick={ toggleTodo }>
      <label ondblclick={ editTodo }>{ todo.title }</label>
      <button class="destroy" onclick={ removeTodo }></button>
    </div>
    <input name="edit_todo" class="edit" type="text" onblur={ doneEdit } onkeyup={ editKeyUp }>
  </li>
  <script>
    var self = this;
    self.todo = opts.data;
    self.parentview = opts.parentview;
    self.editing = false;

    toggleTodo(e) {
      self.todo.completed = !self.todo.completed;
      self.parentview.saveTodos();
      return true
    }

    editTodo(e) {
      self.editing = true;
      self.edit_todo.value = self.todo.title;
    }

    removeTodo(e) {
      self.parentview.removeTodo(self.todo);
    }

    doneEdit(e) {
      self.editing = false;
      var enteredText = self.edit_todo.value && self.edit_todo.value.trim();
      if (enteredText) {
        self.todo.title = enteredText;
        self.parentview.saveTodos();
      } else {
        self.removeTodo();
      }
    }

    editKeyUp(e) {
      if (e.which == 13) { // 监测是否有按enter动作
        self.doneEdit();
      } else if (e.which == 27) {
        self.editing = false;
        self.edit_todo.value = self.todo.title;
      }
    }

    self.on('update', function() {
      if (self.editing) {
        self.parentview.update();
        self.edit_todo.focus();
      }
    })
  </script>
</todo-list>