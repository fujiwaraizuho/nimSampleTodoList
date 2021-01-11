import tasks;
import strutils;

proc backlog(): int =
  echo tasks.index();

  result = 0;

proc addTask(): int =
  stdout.write("Task Name: ");
  let name = stdin.readLine;

  stdout.write("Task Description: ");
  let description = stdin.readLine;

  discard tasks.create(name, description);

  result = 0;

proc updateTask(): int =
  stdout.write("Task ID: ");
  let id = stdin.readLine;
  let task = tasks.show(parseInt(id));

  stdout.write("Task Name: ");
  let name = stdin.readLine;

  stdout.write("Task Description: ");
  let description = stdin.readLine;

  stdout.write("Task Finished? (true or false) : ");
  let done = stdin.readLine;

  let newTask = Task(
    id: task.id,
    name: name,
    description: description,
    done: parseBool(done)
  );

  discard tasks.update(newTask);

  result = 0;

when isMainModule:
  import cligen;
  tasks.init();
  cligen.dispatchMulti([backlog], [addTask], [updateTask]);
