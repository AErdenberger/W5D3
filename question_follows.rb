require 'sqlite3'
require_relative 'questions_database.rb'
require_relative 'users.rb'
require_relative 'questions.rb'

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

    def self.followers_for_question_id(question_id)
        question_follow = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT 
            fname, lname, users.id
        FROM 
            users 
        LEFT JOIN 
            question_follows 
        ON 
            users.id = question_follows.author_id
        WHERE 
            question_id = ?;
        SQL
        return nil unless question_follow.length > 0

        question_follow.map {|follow| User.new(follow)} 
    end

    def self.followed_questions_for_user_id(author_id)
        question_follow = QuestionsDatabase.instance.execute(<<-SQL, author_id)
        SELECT 
            title, body, questions.author_id
        FROM 
            questions
        LEFT JOIN 
            question_follows 
        ON 
            questions.id = question_follows.question_id
        WHERE 
            question_follows.author_id = ?;
        SQL
        return nil unless question_follow.length > 0

        question_follow.map {|follow| Question.new(follow)} 
    end

    def self.most_followed_questions(n)
        question_follow = QuestionsDatabase.instance.execute(<<-SQL, n)
        SELECT
            questions.*
        FROM
            questions
        LEFT JOIN
            question_follows
        ON
            questions.id = question_follows.question_id
        GROUP BY
            question_follows.question_id
        ORDER BY
            COUNT (question_follows.question_id) DESC
        LIMIT
            ?
        SQL
        question_follow.map {|follow| Question.new(follow)} 
    end
         # order by count(author id)



    def initialize(options)
        @id = options['id']
        @author_id = options['author_id']
        @question_id = options['question_id']
    end

end

    # id INTEGER PRIMARY KEY,
    # author_id INTEGER NOT NULL,
    # question_id INTEGER NOT NULL,


   