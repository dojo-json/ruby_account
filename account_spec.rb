require 'rspec'
require_relative 'account'

describe Account do
  before do
    @account = Account.new(350, 1500)
  end

  it "retrieves the account balances" do
    expect(@account.checking).to eq(1500)
    expect(@account.saving).to eq(350)
    expect(@account.totals).to eq(1850)
  end

  it "allows the account holder to deposit funds" do
    expect(@account.deposit(50)).to eql(50)
    expect(@account.saving).to eql(400)

    expect(@account.deposit(500, :checking)).to eql(500)
    expect(@account.checking).to eql(2000)
  end

  it "allows the account holder to withdraw funds" do
    expect(@account.withdraw(50)).to eq(50)
    expect(@account.saving).to eq(300)

    expect(@account.withdraw(150, :checking)).to eq(150)
    expect(@account.checking).to eq(1350)
  end

  it "raises an error if account holder attempts to withdraw more funds than available" do
    expect {
      @account.withdraw(1000000, :checking)
    }.to raise_error(InsufficientFunds)

    expect {
      @account.withdraw(1000000, :saving)
    }.to raise_error(InsufficientFunds)
  end

  it "raises an error if it is not a valid account type" do
    expect {
      @account.withdraw(10, :retirement)
    }.to raise_error(InvalidAccount)
  end

  it "expects total number of accounts to be unavailable to an account holder" do
    expect {
      @account.accounts
    }.to raise_error(NoMethodError)
  end

  it "expects interest rate to be private" do
    expect {
      @account.interest = 0.35
    }.to raise_error(NoMethodError)
  end

  it "can not assign instance variables" do
    expect {
      @account.account_number = 345345345345
    }.to raise_error(NoMethodError)

    expect {
      @account.checking = 1000000000000
    }.to raise_error(NoMethodError)

    expect {
      @account.saving = 1000000000000
    }.to raise_error(NoMethodError)
  end

  it "expects funds back when closing an account" do
    saving, checking = @account.close

    expect(saving).to eql(350)
    expect(checking).to eql(1500)
  end

  it "should raise an error if account is accessed after close" do
    @account.close

    expect {
      @account.deposit(100, :checking)
    }.to raise_error(RuntimeError)
  end

  it "should track the number of accounts" do
    10.times { Account.new }

    expect(Account.accounts).to be > 15
  end
end
