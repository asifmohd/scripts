#!/bin/env/ruby
require('FileUtils')

input_file = ARGV[0]

File.foreach(input_file) do |line|
    line_split = line.split(':')
    file_name = line_split[0].chomp
    line_number = line_split[1].to_i - 1
    next unless File.file?(file_name)
    temp_file = "#{file_name}_modified.swift"
    output_file = File.open(temp_file, 'w')
    File.open(file_name, 'r').each_line.with_index do |code_line, line_num|
        if line_num == line_number
            if code_line.include?('public')
                if code_line.include?('final public class')
                    code_line.gsub!(/public /, '')
                elsif code_line.include?('public class')
                    code_line.gsub!(/public /, 'final ')
                else
                    code_line.gsub!(/public /, '')
                end
                puts(code_line)
            end
        end
        output_file.print(code_line)
    end
    output_file.close
    FileUtils.rm file_name
    FileUtils.mv temp_file, file_name
end

