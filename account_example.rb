require_relative 'account'

account = Account.new(350, 1000)
account.totals

begin
  account.saving = 2000000000000
rescue => e
  puts "You may not assign to savings directly"
end

puts "there is $#{ account.saving } in your saving account"

account.deposit(250)
account.withdraw(100, :checking)
account.totals

begin

  account.withdraw(1000000000, :checking)

rescue => e
  puts e.message
  # puts "You do not have enough money"
end

begin
  puts account.accounts
rescue => e
  puts e
  puts "there is no method to access number of accounts from an instance"
end

Account.accounts

account.account_information

saving, checking = account.close

puts "we closed our account and got $#{ saving } from our saving account and $#{ checking } from checking"

puts "is our account frozen? #{ account.frozen? }"

begin
  account.deposit(50)
rescue => e
  puts "You have closed your account"
end

puts account.inspect
