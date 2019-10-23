class BooksValidator
    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    validates :name, presence: true, if: -> { @create_action }
    validates :price, presence: true, if: -> { @create_action }
    validates :count, presence: true, if: -> { @create_action }
    validates :author, presence: true, if: -> { @create_action }

    validates :price, numericality: true, if: -> { @price }
    validates :count, numericality: true, if: -> { @count }
    validates :published, numericality: true, if: -> { @published }

    attr_accessor :name, :price, :count, :author, :published

    def initialize(params={})
        @name = params[:name]
        @price = params[:price]
        @count = params[:count]
        @author = params[:author]
        @published = params[:published]
        @journal = params[:journal]
        @action = params[:action]
        @create_action = @action == 'create'
        @update_action = @action == 'update'
    end
end