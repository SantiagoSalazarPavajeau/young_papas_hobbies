class Project < ApplicationRecord
    belongs_to :user, counter_cache: true
    belongs_to :hobby
    has_many :project_updates
    has_one_attached :image
    validates :title, presence: true
    validates :description, presence: true, length: {minimum: 25}

   

    def hobby_title=(title)
        self.hobby = Hobby.find_or_create_by(title: title.strip)
    end

    def hobby_title
        self.hobby ? self.hobby.title : nil
    end

    validate :is_title_case
    before_validation :make_title_case

    # model class method
    def self.count_by_user
        all.group(:user_id).count # [1, 5]
    end
 
    private
    def is_title_case
        if title.split.any?{|w|w[0].upcase != w[0]}
        errors.add(:title, "Title must be in title case")
        end
    end
    
    def make_title_case
        # Rails provides a String#titlecase method
        self.title = self.title.titlecase
    end
end
