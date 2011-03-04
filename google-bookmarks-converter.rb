#!/usr/bin/env ruby

bookmark_filename = "GoogleBookmarks.html"
bookmarks = {}
current_label = nil
label_regex = /^<DT><H3.*>(.*)<\/H3>$/
bookmark_regex = /^<DT><A HREF="(.*)" ADD_DATE="(.*)">(.*)<\/A>$/

File.open(bookmark_filename, 'r') do |f|  
  while line = f.gets  
    if line =~ label_regex
      current_label = line.match(label_regex)[1].gsub(',','_')
    elsif current_label and line =~ bookmark_regex
      bookmark_arr_data = line.match(bookmark_regex).to_a
      bookmark_data = {
        :tags => [current_label],
        :url => bookmark_arr_data[1],
        :add_date => bookmark_arr_data[2],
        :title => bookmark_arr_data[3],
      }
      if bookmarks[bookmark_data[:url]]
        bookmarks[bookmark_data[:url]][:tags] << current_label
      else
        bookmarks[bookmark_data[:url]] = bookmark_data
      end
    end
  end  
end

puts <<eos
<!DOCTYPE NETSCAPE-Bookmark-file-1>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=UTF-8">
<TITLE>Bookmarks</TITLE>
<H1>Bookmarks</H1>
<DL><p>
eos

bookmarks.each do |key, data|
  puts "<DT><A HREF=\"#{data[:url]}\" ADD_DATE=\"#{data[:add_date]}\" PRIVATE=\"0\" TAGS=\"#{data[:tags].join(',')}\">#{data[:title]}</A>"
end

puts '</DL><p>'

