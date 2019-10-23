class Book < ApplicationRecord
    validates :name, presence: true
    validates_uniqueness_of :name, scope: :journal, case_sensitive: true
end
