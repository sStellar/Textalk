require_relative "twapi_back"
require_relative "print_h"
require_relative "del_key_value"


class Frontend
  def initialize
    @temp_json = {
      "jsonrpc" => "2.0",
      "id" => 1,
      "method" => "",
      "params" => []
    }
  end

  def clear
    system('cls')
    system('clear')
  end

  def print_arr(array, *extra)
    s = 0
    i = 0
    while i < array.length
      if array[i].include?('%') == false
        puts array[i]
      else
        puts array[i] % extra[s].to_s
        s += 1
      end
      i += 1
    end
  end

  def spec_Name_lang()
    clear
    ch = ""
    choices = [
      "Please select a language:",
      "[1] Swedish",
      "[2] English (unavailable)",
      "[3] All",
      "Choose one:"
    ]
    choice_hash = {
      1 => "sv",
      2 => true, # true for now, english isnt an option as none of the articles have a name in english, only swedish
      3 => true
    }

    # No case handling because there will only be swedish, so only 1 option is available

    print_arr(choices)
    ch = gets.to_i
    return choice_hash[ch]
  end

  def spec_Article_group()
    clear
    #puts "art gr past clear"
    ch = ""
    chosen = []
    choices = [
      "Please select article group info",
      "[1] Group name",
      "[2] Group base name",
      "[3] Group id",
      "[4] Group description",
      "[5] Link to group",
      "[6] Hidden?",
      "[7] All",
      "[0] Done",
      "Chosen paramters: %s",
      "Choose paramter:"
    ]
    choice_hash = {
      1 => "name",
      2 => "baseName",
      3 => "uid",
      4 => "description",
      5 => "url",
      6 => "hidden"
    }

    until chosen.include?(7) || chosen.include?(0) || chosen.length >= 6
      clear
      print_arr(choices, chosen)
      ch = gets.to_i
      chosen += [ch]
    end

    index = 0
    while index < chosen.length
      case chosen[index]
      when 7
        return {}
      when 0
        chosen -= [0]
      else
        chosen[index] = choice_hash[chosen[index]]
      end

      index += 1
    end
    return chosen
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

    print_arr(menu, [])
    choice = gets.to_i
    choice = choice_hash[choice]
    return choice
  end

  def article_get()
    clear
    payload = @temp_json.dup
    payload["method"] = "Article.get"
    params = []
    chosen = []
    temp_param_str = {}
    choice = ""
    uid = ""
    available_params = [
      "UID: %s",
      "Available parameters:",
      "[1] Name",
      "[2] Article number",
      "[3] Article group",
      "[4] All",
      "[0] Done",
      "Chosen parameters: %s",
      "Choose Parameter:"
    ]
    param_hash = {
      1 => {"name" => true},
      2 => {"articleNumber" => true},
      3 => {"articlegroup" => {}}
    }

    #uid = gets.to_i
    uid = 172139951
    params += [uid]

    until chosen.include?(4) || chosen.include?(0) || chosen.length >= 3
      clear
      print_arr(available_params, uid, chosen)
      choice = gets.to_i
      chosen += [choice]
    end

    chosen_index = 0
    while chosen_index < chosen.length
      case chosen[chosen_index]
      when 4
        lang = spec_Name_lang()
        #articlegroup = spec_Article_group()
        temp_param_str = {"name" => lang, "articleNumber" => true, "articlegroup" => articlegroup}
        #params = [uid, {"name" => lang, "articleNumber" => true, "articlegroup" => {}}]
        break
      when 1
        lang = spec_Name_lang()
        temp_param_str.merge!({"name" => lang})
      when 2
        temp_param_str.merge!({"articleNumber" => true})
      when 3
        articlegroup = spec_Article_group()
        temp_param_str.merge!({"articlegroup" => articlegroup})
      when 0
        chosen -= [0]
        break
      end
      chosen_index += 1
    end
    params = [uid, temp_param_str]


    payload["params"] = params
    return payload
  end
end

r = Twapi.new
x = Frontend.new
running = true
while running
  x.clear
  x.start_menu
  result = r.sendToApi(x.article_get)
  result = JSON.parse(result)
  result = result.without("jsonrpc","id")
  print_h(result)
  gets
end
