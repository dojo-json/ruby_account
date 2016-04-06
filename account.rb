class Account
  attr_reader :account_number, :checking, :saving

  @@accounts = 0

  def initialize(saving = 0.0, checking = 0.0)
    raise InvalidAmount if saving < 0 || checking < 0
    @account_number = generate_account_number
    @checking = checking
    @saving = saving

    @@accounts += 1
    @interest = 3.5
  end

  def totals
    puts "You have this amount in savings: #{ @saving }"
    puts "You have this amount in checking: #{ @checking }"
    puts "Your total deposits are #{ @saving + @checking }"
    @saving + @checking
  end

  def deposit(amount, account = :saving)
    raise InvalidAccount unless account_types.include?(account)
    @saving += amount if account == :saving
    @checking += amount if account == :checking
    amount
  end

  def withdraw(amount, account = :saving)
    raise InvalidAccount unless account_types.include?(account)
    raise InsufficientFunds unless account == :saving ? sufficient_saving?(amount) : sufficient_checking?(amount)
    withdraw_saving(amount) if account == :saving
    @checking -= amount if account == :checking
    amount
  end

  def account_information
    puts "Your account number is #{ @account_number }"
    puts "The current interest rate is #{ @interest }%"
    totals
    self
  end

  def close
    funds = [@saving, @checking]
    @saving -= @saving
    @checking -= @checking

    @@accounts -= 1

    self.freeze

    funds
  end

  def account_types
    [:saving, :checking]
  end

  # class methods

  def self.accounts
    puts "There are #{ @@accounts } accounts opened"
    @@accounts 
  end

  # private methods

  private
  def withdraw_saving(amount)
    @saving -= amount
  end

  def sufficient_saving?(amount)
    @saving >= amount
  end

  def sufficient_checking?(amount)
    @checking >= amount
  end

  def generate_account_number
    rand(10 ** 12)
  end
end


InvalidAccount    = Class.new(StandardError)
InvalidAmount     = Class.new(StandardError)

class InsufficientFunds < StandardError
  attr_reader :message
  def initialize(*)
    @message = "You do not have enough money to complete this transaction"
  end
end
