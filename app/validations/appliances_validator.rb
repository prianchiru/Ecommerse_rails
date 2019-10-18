class AppliancesValidator
    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    validates :name, presence: true, if: -> { @create_action }
    validates :price, presence: true, if: -> { @create_action }
    validates :count, presence: true, if: -> { @create_action }
    validates :brand, presence: true, if: -> { @create_action }

    validates :price, numericality: true, if: -> { @price }
    validates :count, numericality: true, if: -> { @count }

    attr_accessor :name, :price, :count, :brand, :model

    def initialize(params={})
        @name = params[:name]
        @price = params[:price]
        @count = params[:count]
        @model = params[:model]
        @brand = params[:brand]
        @action = params[:action]
        @create_action = @action == 'create'
        @update_action = @action == 'update'
    end
end