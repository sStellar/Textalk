require_relative "twapi_back"
require_relative "del_key_value"
require_relative "print"
require_relative "Article.get"


class Frontend
  include Get
  def initialize
    @temp_json = {
      "jsonrpc" => "2.0",
      "id" => 1,
      "method" => "",
      "params" => []
    }
  end

  def start_menu()
    clear
    choice_hash = {
      1 => "article_get",
      2 => "article_count",
      3 => "article_create",
      4 => "article_set"
    }
    menu = [
      "[1] Get Article info (with known uid)",
      "[2] Count Articles",
      "[3] Create Article",
      "[4] Update Article",
      "Enter choice:"
    ]

    print_a(menu, [])
    choice = gets.to_i
    choice = choice_hash[choice]
    return choice
  end
end

r = Twapi.new
x = Frontend.new
running = true
while running
  clear
  x.start_menu
  result = JSON.parse(r.sendToApi(x.article_get))
  result = result.without("jsonrpc","id")
  print_h(result)
  gets
end
