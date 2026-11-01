local title_cache = {}

local function get_frontmatter_title(filepath)
  if not filepath or not filepath:match("%.md$") then
    return nil
  end
  if title_cache[filepath] ~= nil then
    return title_cache[filepath] ~= false and title_cache[filepath] or nil
  end
  local f = io.open(filepath, "r")
  if not f then
    title_cache[filepath] = false
    return nil
  end
  local in_frontmatter = false
  local result = nil
  for _ = 1, 20 do
    local line = f:read("*l")
    if not line then
      break
    end
    if in_frontmatter then
      if line:match("^%-%-%-$") then
        break
      end
      local title = line:match('^title:%s*"?(.-)"?%s*$')
      if title then
        result = title
        break
      end
    elseif line:match("^%-%-%-$") then
      in_frontmatter = true
    else
      break
    end
  end
  f:close()
  title_cache[filepath] = result or false
  return result
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      close_if_last_window = false,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      window = {
        mappings = {
          ["c"] = "none",
          ["r"] = function(state)
            title_cache = {}
            require("neo-tree.sources.manager").refresh(state.name)
          end,
        },
      },
      filesystem = {
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        components = {
          name = function(config, node, state)
            local display = node.name
            if node.type == "file" and node.path then
              local title = get_frontmatter_title(node.path)
              if title then
                display = title
              end
            end
            return {
              text = display,
              highlight = config.highlight or "NeoTreeFileName",
            }
          end,
        },
      },
      sort_function = function(a, b)
        local function is_in_notes_directory(path)
          return string.match(path, "/notes/") or string.match(path, "^notes/")
        end
        local function get_mod_time(path)
          local attributes = vim.loop.fs_stat(path)
          return attributes and attributes.mtime.sec or 0
        end
        if a.type ~= b.type then
          return a.type == "directory"
        end
        local a_in_notes = is_in_notes_directory(a.path)
        local b_in_notes = is_in_notes_directory(b.path)
        if a_in_notes and b_in_notes and a.type ~= "directory" and b.type ~= "directory" then
          return get_mod_time(a.path) > get_mod_time(b.path)
        end
        local a_name = a.path:match("^.+/(.+)$") or a.path
        local b_name = b.path:match("^.+/(.+)$") or b.path
        return a_name < b_name
      end,
    },
  },
}
