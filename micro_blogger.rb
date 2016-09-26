require 'jumpstart_auth'
require 'bitly'

class MicroBlogger
	attr_reader :client

	def initialize
		puts "Initializing MicroBlogger"
		@client = JumpstartAuth.twitter
	end

	def run
		puts "Welcome to the JSL Twitter Client!"
		command = ""
		while command != "q"
			printf "Enter command: "
			input = gets.chomp
			parts = input.split(" ")
			command = parts[0]
			case command
			when 'q' then puts "Goodbye!"
			when 't' then tweet(parts[1..-1].join(" "))
			when 'dm' then dm(parts[1], parts[2..-1].join(" "))
			when 'spam' then spam_followers(parts[1..-1].join(" "))
			when 'elt' then everyone_last_tweet
			when 's' then shorten(parts[1..-1])
			when 'turl' then tweet(parts[1..-2].join(" ") + " " + shorten(parts[-1]))
			else
				puts "Sorry, I don't recognize the command '#{command}'"
			end
		end
	end

	def tweet(message)
		if message.size > 140
			puts "ERROR: The message is too long. Only 140 characters allowed."
		else
		@client.update(message)
		end
	end

	def dm(target, message)
		if followers_list.include?(target)
			puts "Sending to #{target} this message:"
			puts message
			message = "d @#{target} #{message}"
			tweet(message)
		else
			puts "ERROR: You can only DM people who are following you"
		end
	end

	def spam_followers(message)
		followers_list.each { |user|
			dm(user, message)
		}
	end

	def everyone_last_tweet
		@friends = @client.friends.sort_by { |friend| friend.screen_name.downcase }
		friends.each do |friend|
			timestamp = friend.status.created_at
			puts "#{friend.screen_name} said..."
			puts "#{friend.status.text}"
			puts "created at: #{timestamp.strftime("%A, %b %d")}"
			puts ""
		end
	end

	def followers_list
		screen_name = @client.followers.collect { |follower| @client.user(follower).screen_name }
		return screen_name
	end

	def shorten(original_url)
		bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
		puts "Shortening this URL: #{original_url}"
		return bitly.shorten(original_url).short_url
	end
end

blogger = MicroBlogger.new
blogger.run

















