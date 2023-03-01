PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS question_likes;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;

CREATE TABLE users(
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

CREATE TABLE questions(
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,

    FOREIGN KEY (author_id) REFERENCES users(id)
);


CREATE TABLE question_follows(
    id INTEGER PRIMARY KEY,
    author_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    
    FOREIGN KEY (author_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);


CREATE TABLE replies(
    id INTEGER PRIMARY KEY,
    body TEXT NOT NULL,
    author_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    parent_reply_id INTEGER,
    
    FOREIGN KEY (author_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_reply_id) REFERENCES replies(id)
    
);


CREATE TABLE question_likes(
    id INTEGER PRIMARY KEY,
    author_id INTEGER NOT NULL,
    question_id INTEGER NOT NULL,
    
    FOREIGN KEY (author_id) REFERENCES users(id),
    FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO users(fname, lname)
VALUES 
    ("Josh", "van Eyken"),
    ("Alex", "Erdenberger"),
    ("Kevin", "Bacon");

INSERT INTO questions(title, body, author_id)
VALUES
    ("Why Sky?", "Why is the sky blue?", (SELECT id FROM users WHERE fname = 'Josh' AND lname = 'van Eyken')),
    ("Kevin Bacon?", "How many steps away am I removed from Kevin Bacon?", (SELECT id FROM users WHERE fname = 'Alex' AND lname = 'Erdenberger')),
    ("Let's talk about me.", "Why Am I so great?", (SELECT id FROM users WHERE fname = "Kevin" AND lname = "Bacon"));

