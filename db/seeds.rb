admin = Admin.create!(
  email: 'admin@example.com',
  password: 'password' 
)
admin.create_wallet(balance: admin.initial_wallet_balance)

10.times do |i|
  user = User.create!(
    email: "user#{i + 1}@example.com",
    password: 'password'
  )
  user.create_wallet(balance: user.initial_wallet_balance)
end

User.all.each do |user|
  Wallet.create!(user: user, balance: user.initial_wallet_balance)
end

user = User.find_by(id: current_user.id) 
loan = Loan.new(
  amount: 1000,
  interest_rate: 5.0,
  term: 12,
  user: user 
)

loan.save
