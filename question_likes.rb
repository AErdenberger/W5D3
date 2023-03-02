require 'sqlite3'
require_relative 'questions_database.rb'
require_relative 'users.rb'
require_relative 'questions.rb'

class QuestionLike

    attr_accessor :id, :author_id, :question_id

    def self.find_by_id(id)
        question_likes = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                question_likes
            WHERE
                id = ?
        SQL
        return nil unless question_likes.length > 0
        QuestionLike.new(question_likes.first)
    end

    def self.find_by_author_id(author_id)
        question_likes = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT
                *
            FROM
                question_likes
            WHERE
                author_id = ?
        SQL
        return nil unless question_likes.length > 0
        
        question_likes.map { |likes| QuestionLike.new(likes) }
    end

    def self.likers_for_question_id(question_id)
        question_likes = QuestionsDatabase.instance.execute(<<-SQL, question_id)
        SELECT 
            users.*
        FROM 
            users 
        LEFT JOIN 
            question_likes 
        ON 
            users.id = question_likes.author_id
        WHERE 
            question_id = ?;
        SQL
        return nil unless question_likes.length > 0

        question_likes.map {|like| User.new(like)}
    end

    def initialize(options)
        @id = options['id']
        @author_id = options['author_id']
        @question_id = options['question_id']
    end

end


#     id INTEGER PRIMARY KEY,
#     author_id INTEGER NOT NULL,
#     question_id INTEGER NOT NULL,