class ProductTrading
    def self.buy_product(category, product, count)
        sql = "update #{category} set count = count - #{count} where name = '#{product}'"
        result = ApplicationRecord.connection.execute(sql)
    end

    def self.add_product(category, product, count)
        sql = "update #{category} set count = count + #{count} where name = '#{product}'"
        ApplicationRecord.connection.execute(sql)
    end
end