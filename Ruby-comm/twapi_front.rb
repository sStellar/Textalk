require_relative "twapi_back"

class Frontend
  def initialize
    @temp_json = {
      "jsonrpc" => "2.0",
      "id" => 1,
      "method" => "",
      "params" => []
    }
  end

  def clear_screen()
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
    ch = ""
    choices = [
      "Please select a language:",
      "[1] Swedish",
      "[2] English (unavailable)",
      "[3] All",
      "[0] Done",
      "Chosen languages: [%s]",
      "Enter selection:"
    ]
    choice_hash = {
      1 => "sv",
      2 => "en",
      3 => true
    }
    until choice_hash[ch].include?(3) || choice_hash[ch].include?(0) || choice

      print_arr(choices, ch)
    end
  end

  def spec_Article_group


  end

  def start_menu()
    clear_screen()
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
    clear_screen()
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
      clear_screen()
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
        #articlegroup = spec_Article_group()
        temp_param_str.merge!({"articlegroup" => {}})
      when 0
        chosen -= [0]
      end
      chosen_index += 1
    end
    params = [uid, temp_param_str]
=begin
    temp_param_str = {}
    if chosen.include?(4)
      params = [uid, {"name" => true, "articleNumber" => true, "articlegroup" => {}}]
    else
      for i in 0..chosen.length
        if chosen[i] == 0
          chosen -= [0]
        else
          unless chosen[i] == nil
            #temp_param_str[chosen[i]] = param_hash[chosen[i]]
            temp_param_str = temp_param_str.merge(param_hash[chosen[i]])
          end
        end
      end
      #p temp_param_str
      #temp_param_str = temp_param_str.include?("}{") ? temp_param_str.gsub("}{", ",") : temp_param_str
      #temp_param_str.gsub!('\"', '"')
    end

    puts "Temp Param Str:"
    p temp_param_str
    puts "Chosen:"
    p chosen
    puts "Params:"
    p params
=end

    payload["params"] = params
    return payload
  end
end

x = Frontend.new
x.clear_screen
# p x.article_get
r = Twapi.new
x.start_menu
result = r.sendToApi(x.article_get)
puts JSON.parse(result)
