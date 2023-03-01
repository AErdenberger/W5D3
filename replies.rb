require 'sqlite3'
require_relative 'questions_database.rb'
require_relative 'users.rb'
require_relative 'questions.rb'


class Reply

    attr_accessor :body, :author_id, :id, :parent_reply_id, :question_id

    def self.find_by_id(id)
        reply = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                replies
            WHERE
                id = ?
        SQL
        return nil unless reply.length > 0
        Reply.new(reply.first)
    end

    def self.find_by_author_id(author_id)
        replies = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT
                *
            FROM
                replies
            WHERE
                author_id = ?
        SQL
        return nil unless replies.length > 0
        replies.map { |reply| Reply.new(reply) }
    end

    def self.find_by_parent_reply_id(parent_reply_id)
        replies = QuestionsDatabase.instance.execute(<<-SQL, parent_reply_id)
            SELECT
                *
            FROM
                replies
            WHERE
                parent_reply_id = ?
        SQL
        return nil unless replies.length > 0
        replies.map { |reply| Reply.new(reply) }
    end

    def self.find_by_question_id(question_id)
        replies = QuestionsDatabase.instance.execute(<<-SQL, question_id)
            SELECT
                *
            FROM
                replies
            WHERE
                question_id = ?
        SQL
        return nil unless replies.length > 0
        replies.map { |reply| Reply.new(reply) }
    end

    def initialize(options)
        @id = options['id']
        @body = options['body']
        @author_id = options['author_id']
        @question_id = options['question_id']
        @parent_reply_id = options['parent_reply_id']
    end

    def author
        User.find_by_id(author_id)
    end

    def question
        Question.find_by_id(question_id)
    end

    def parent_reply
        Question.find_by_id(parent_reply_id)
    end

    def child_replies
        Reply.find_by_parent_reply_id(id)
    end

end

#     id INTEGER PRIMARY KEY,
#     body TEXT NOT NULL,
#     author_id INTEGER NOT NULL,
#     question_id INTEGER NOT NULL,
#     parent_reply_id INTEGER,