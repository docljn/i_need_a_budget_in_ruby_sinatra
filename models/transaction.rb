# transaction.rb
require('pry-byebug')
require_relative('../db/sql_runner.rb')

class Transaction
  attr_reader :id
  attr_accessor :amount, :category_id, :vendor_id, :comment, :account_id


  def initialize(options)
    @id = options['id'].to_i if options['id']
    @amount = options['amount'].to_i
    @comment = options['comment']
    @category_id = options['category_id']
    @vendor_id = options['vendor_id']
    @account_id = options['account_id']
    # add date as an extension later: this will be tricky
  end

  # delete
  def self.delete_all()
    sql = "DELETE FROM transactions;"
    sql_result = SqlRunner.run(sql)
  end

  # delete
  def self.delete_one(id)
    sql = "DELETE FROM transactions WHERE id = $1;"
    values = [id]
    sql_result = SqlRunner.run(sql, values)
  end

  # read
  def self.select_all()
    sql = "SELECT * FROM transactions;"
    sql_result = SqlRunner.run(sql)
    transactions_array = sql_result.map {|hash| Transaction.new(hash)}
  end

  # read
  def self.select_one(id)
    sql = "SELECT * FROM transactions where id = $1;"
    values = [id]
    sql_result = SqlRunner.run(sql, values)
    transaction = Transaction.new(sql_result[0])
  end

  def save()
    if @id
      update()
    else
      insert()
    end
  end


  private
  def insert()
    sql = "INSERT INTO transactions
    (amount, category_id, vendor_id, comment, account_id)
    VALUES
    ($1, $2, $3, $4, $5)
    RETURNING id;"
    values = [@amount, @category_id, @vendor_id, @comment, @account_id]
    sql_result = SqlRunner.run(sql, values)
    @id = sql_result[0]['id']
  end

  def update()
    sql = "UPDATE transactions SET (amount, category_id, vendor_id, comment, account_id) = ($1, $2, $3, $4, $5) where id = $6;"
    values = [@amount, @category_id, @vendor_id, @comment, @account_id, @id]
    sql_result = SqlRunner.run(sql, values)
  end


end
# transaction.rb
