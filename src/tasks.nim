import db_sqlite;
import strutils;

type
    Task* = object
        id*: int
        name*: string
        description*: string
        done*: bool

proc init* () =
    let db = open("tasks.db", "", "", "");
    defer:
        db.close();

    let cmd = sql"CREATE TABLE IF NOT EXISTS TASK(ID INTEGER PRIMARY KEY, NAME TEXT NOT NULL, DESCRIPTION TEXT NOT NULL, DONE INTEGER NOT NULL)";
    discard db.tryExec(cmd);

proc create* (name: string, description: string, done: bool = false): Task =
    let db = open("tasks.db", "", "", "");
    let id = db.tryInsertID(
        sql"INSERT INTO TASK (name, description, done) VALUES(?, ?, ?)",
        name, description, done
    );

    db.close();

    echo "タスク「 " & name & " 」を登録しました！";

    result = Task(
        id: id.int,
        name: name,
        description: description,
        done: done
    );

proc index* (): seq[Task] =
    let db = open("tasks.db", "", "", "");
    let tasks = db.getAllRows(sql"SELECT id, name, description, done FROM TASK");

    result = @[];

    for task in tasks:
        result.add(
            Task(
                id: parseInt(task[0]),
                name: task[1],
                description: task[2],
                done: parseBool(task[3])
            )
        );

proc show* (id: int): Task =
    let db = open("tasks.db", "", "", "");
    let task = db.getRow(sql"SELECT id, name, description, done FROM task WHERE id = ?", id);

    result = Task(
        id: parseInt(task[0]),
        name: task[1],
        description: task[2],
        done: parseBool(task[3])
    );

proc update* (task: Task): Task =
    let db = open("tasks.db", "", "", "");

    db.exec(
        sql"UPDATE TASK SET name = ?, description = ?, done = ? WHERE id = ?",
        task.name,
        task.description,
        task.done,
        task.id
    );

    echo "タスク「 " & task.name & " 」を更新しました！";

    result = task;

proc destroy* (id: int): Task =
    let db = open("tasks.db", "", "", "");
    let task = db.getRow(sql"SELECT id, name, description, done FROM task WHERE id = ?", id);

    db.exec(sql"DELETE FROM task WHERE id = ?", id);

    let name = task[0];

    echo "タスク「 " & name & " 」を削除しました！";

    result = Task(
        id: parseInt(task[0]),
        name: task[1],
        description: task[2],
        done: parseBool(task[3])
    );