require 'sqlite3'
require_relative 'questions_database.rb'
require_relative 'users.rb'
require_relative 'replies.rb'
require_relative 'question_follows.rb'


class Question

    attr_accessor :id, :title, :body, :author_id

    def self.find_by_id(id)
        question = QuestionsDatabase.instance.execute(<<-SQL, id)
            SELECT
                *
            FROM
                questions
            WHERE
                id = ?
        SQL
        return nil unless question.length > 0
        Question.new(question.first)
    end

    def self.find_by_author_id(author_id)
        questions = QuestionsDatabase.instance.execute(<<-SQL, author_id)
            SELECT
                *
            FROM
                questions
            WHERE
                author_id = ?
        SQL
        return nil unless questions.length > 0
        questions.map {|question| Question.new(question)}
    end

    def self.most_followed(n=1)
        QuestionFollow.most_followed_questions(n)
    end

    def self.most_liked(n=1)
        QuestionLike.most_liked_question(n)
    end

    def initialize(options)
        @id = options['id']
        @title = options['title']
        @body = options['body']
        @author_id = options['author_id']
    end

    def author
        User.find_by_id(author_id)
    end 

    def replies
        Reply.find_by_question_id(id)
    end

    def followers
        QuestionFollow.followers_for_question_id(id)
    end

    def likers 
        QuestionLike.likers_for_question_id(id)
    end

    def num_likes
        QuestionLike.num_likes_for_question_id(id)
    end

end