class Appliance < ApplicationRecord
    validates :name, presence: true
    validates_uniqueness_of :name, scope: :warrenty_in_years, case_sensitive: true
end
