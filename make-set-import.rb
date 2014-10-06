#!/usr/bin/env ruby

ARGF.each do |line|
  if line =~ /set`/
    oldline = line.split(' = ')[0]
    oldline.gsub!('%abbrev','').strip!
    newline = oldline.gsub('not-member','fresh')
    newline.gsub!('member?','domain?')
    newline.gsub!('union','join')
    newline.gsub!('set`','')
    puts "%abbrev #{newline} = #{oldline}."
  end
end
