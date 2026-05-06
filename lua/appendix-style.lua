-- appendix-style.lua
-- Restyle appendix headings to non-TOC paragraph styles.
--
-- Detection: walks headers top-down. When it sees a level-1 Header
-- whose text starts with "Reference" (the References chapter), the
-- next level-1 Header flips into appendix mode. All subsequent
-- headers are converted to styled paragraphs (AppHead1, Head2NonTOC,
-- Head3NonTOC) so they don't appear in the Word TOC.

local style_map = {
  [1] = "AppHead1",
  [2] = "Head2NonTOC",
  [3] = "Head3NonTOC",
}

local found_references = false
local in_appendix = false

return {{
  traverse = 'topdown',
  Header = function(h)
    -- Detect the References heading (level 1, text starts with "Reference")
    if h.level == 1 and not found_references then
      if pandoc.utils.stringify(h.content):lower():match("^reference") then
        found_references = true
        return nil
      end
    end

    -- Next H1 after References flips into appendix mode
    if found_references and not in_appendix and h.level == 1 then
      in_appendix = true
    end

    -- In appendix: convert Header to styled paragraph
    if in_appendix then
      local style = style_map[h.level]
      if style then
        local div = pandoc.Div(
          {pandoc.Para(h.content)},
          {['custom-style'] = style}
        )
        div.identifier = h.identifier
        return {div}
      end
    end

    return nil
  end,
}}
