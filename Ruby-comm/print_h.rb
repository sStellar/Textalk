# Print content of hashes and nested hashes recursively

@print_h_count = 0 # Count for indentation of keys and values

# Public: Prints a hash' key and value pairs, if the value is another hash it indents it and does the same
#
# input - Hash to be printed
#
# Example:
#   print_h({"foo"=>"bar", 1=>12})
#   # =>
#   foo:
#     bar
#   1:
#     12:
#
#   print_h({"foo"=>"bar", "baz"=>{1=>"aa",2=>"bb"}})
#   # =>
#   foo:
#     bar
#   baz:
#     1:
#       aa
#     2:
#       bb
#
# Returns nil
def print_h(input)
  input.each do |key, value|
    print "\n#{" " * @print_h_count}#{key}:"
    if value.is_a?(Hash)
      @print_h_count += 2
      print_h(value)
    else
      puts "\n#{" " * (@print_h_count+2)}#{value}"
    end
  end
  if @print_h_count >= 2
    @print_h_count -= 2
  end
end
