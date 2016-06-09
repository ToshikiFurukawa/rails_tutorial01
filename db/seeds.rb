User.create!(name:  "Sample",
             email: "sample@sample.org",
             password:              "smple0",
             password_confirmation: "smple0",
             admin: true)

99.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@smple.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end
