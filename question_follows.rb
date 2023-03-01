require 'sqlite3'
require_relative 'questions_database.rb'

class QuestionFollow

    attr_accessor :id, :author_id, :question_id

    def self.find_by_id(id)
        question_follow = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                question_follows
            WHERE
                id = ?
        SQL
        return nil unless question_follow.length > 0
        QuestionFollow.new(question_follow.first)
    end

    def initialize(options)
        @id = options['id']
        @author_id = options['author_id']
        @question_id = options['question_id']
    end

end

    # id INTEGER PRIMARY KEY,
    # author_id INTEGER NOT NULL,
    # question_id INTEGER NOT NULL,