local json_to_types = require("json-to-types")
local utils = require("json-to-types.utils")

---@param on_choice fun(language: string)
local function select_language(on_choice)
  vim.ui.select(utils.language_map, {
    prompt = "Select target language",
  }, function(choice)
    if not choice then
      return
    end
    on_choice(choice)
  end)
end

vim.api.nvim_create_user_command("ConvertJSONtoLang", function(args)
  if not json_to_types.convertTypes then
    vim.notify("convertTypes function not found", vim.log.levels.ERROR)
    return
  end

  if args.args ~= "" then
    json_to_types.convertTypes(args.args)
    return
  end

  select_language(function(choice)
    json_to_types.convertTypes(choice)
  end)
end, {
  nargs = "?",
  complete = function()
    return utils.language_map
  end,
  desc = "Convert JSON to Typescript",
})

vim.api.nvim_create_user_command("ConvertJSONtoLangBuffer", function(args)
  if not json_to_types.convertTypesBuffer then
    vim.notify("convertTypesBuffer function not found", vim.log.levels.ERROR)
    return
  end

  if args.args ~= "" then
    json_to_types.convertTypesBuffer(args.args)
    return
  end

  select_language(function(choice)
    json_to_types.convertTypesBuffer(choice)
  end)
end, {
  nargs = "?",
  complete = function()
    return utils.language_map
  end,
  desc = "Convert JSON to Typescript",
})
