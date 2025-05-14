require "io/console"

namespace :users do
  desc "Create a new user"
  task create: :environment do
    print "Enter email: "
    email = STDIN.gets.chomp

    print "Enter password: "
    password = STDIN.noecho(&:gets).chomp
    puts

    print "Confirm password: "
    password_confirmation = STDIN.noecho(&:gets).chomp
    puts

    if password != password_confirmation
      puts "❌ Passwords don't match"
      exit 1
    end

    user = User.new(email: email, password: password)

    if user.save
      puts "✅ User created successfully!"
    else
      puts "❌ Failed to create user:"
      user.errors.full_messages.each do |message|
        puts "  - #{message}"
      end
    end
  end
end
