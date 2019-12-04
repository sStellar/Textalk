module Get
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

    print_a(choices)
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

    param_count = choices.length - 5
    until chosen.include?(param_count+1) || chosen.include?(0) || chosen.length >= param_count
      clear
      print_a(choices, chosen)
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
      "[4] Price",
      "[5] All",
      "[0] Done",
      "Chosen parameters: %s",
      "Choose Parameter:"
    ]
    param_hash = {
      1 => {"name" => true},
      2 => {"articleNumber" => true},
      3 => {"articlegroup" => {}},
      4 => {"price"=>true}
    }

    #uid = gets.to_i
    uid = 172139951
    params += [uid]

    param_count = available_params.length - 6
    until chosen.include?(param_count+1) || chosen.include?(0) || chosen.length >= param_count
      clear
      print_a(available_params, uid, chosen)
      choice = gets.to_i
      chosen += [choice]
    end

    chosen_index = 0
    while chosen_index < chosen.length
      case chosen[chosen_index]
      when param_count+1
        lang = spec_Name_lang()
        articlegroup = spec_Article_group()
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
      when 4
        temp_param_str.merge!({"price" => true})
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
