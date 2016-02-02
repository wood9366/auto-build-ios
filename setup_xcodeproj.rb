#!/usr/bin/ruby

require 'xcodeproj'

if ARGV.length > 0 then
	p = Xcodeproj::Project.open(ARGV[0])

	target = p.targets.find { |x| x.name == 'Unity-iPhone' }

	p.targets.each do |target|
		# puts "Target: #{target.name}"
		target.build_configurations.each do |config|
			# puts "Config: #{config.name}"
			config.build_settings['ENABLE_BITCODE'] = 'NO'
			config.build_settings['CODE_SIGN_RESOURCE_RULES_PATH'] = "$(SDKROOT)/ResourceRules.plist"
		end
	end

	p.save
else
	puts "Must specific xcode project to config"
end
