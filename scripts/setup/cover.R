# nolint start
# cover.R
# ----------------------------------------------------------------------
# Functions to build cover pages from params.yml data.
# Each function receives `params` (parsed from params.yml$params).
# ----------------------------------------------------------------------

# -- Internal helper ---------------------------------------------------
escape_html <- function(x) {
  x <- gsub("&", "&amp;", x, fixed = TRUE)
  x <- gsub("<", "&lt;", x, fixed = TRUE)
  x <- gsub(">", "&gt;", x, fixed = TRUE)
  x <- gsub('"', "&quot;", x, fixed = TRUE)
  x
}

# -- Citation builder ---------------------------------------------------
# {consultant}. {year}. {title}: {site}. {location} prepared for {client}, {city}.
build_citation <- function(params) {
  paste0(
    params$consultant$name, ". ", params$year, ". ",
    params$title, ": ", params$site, ". ",
    params$location, " prepared for ",
    params$client$name, ", ", params$client$city, "."
  )
}

# -- Report cover (HTML) -----------------------------------------------
build_cover_report <- function(params) {
  h <- escape_html

  site_location <- paste0(params$site, ". ", params$location)
  project_lines <- paste0(
    '          <div class="srk-cover__project-line">', h(params$title), "</div>",
    collapse = "\n"
  )

  # Client block
  client_addr <- paste0("            <p>", h(params$client$address), "</p>", collapse = "\n")
  client_web_display <- sub("^https?://", "", params$client$web)
  client_block <- paste0(
    '        <section class="srk-cover__block">\n',
    '          <h2 class="srk-cover__block-title">Prepared for:</h2>\n',
    '          <div class="srk-cover__block-body">\n',
    '            <p>', h(params$client$name), '</p>\n',
    client_addr, '\n',
    '            <p><a href="', h(params$client$web), '">', h(client_web_display), '</a></p>\n',
    '          </div>\n',
    '        </section>'
  )

  # Consultant block
  consult_addr <- paste0("            <p>", h(params$consultant$address), "</p>", collapse = "\n")
  consultant_block <- paste0(
    '        <section class="srk-cover__block">\n',
    '          <h2 class="srk-cover__block-title">Prepared by:</h2>\n',
    '          <div class="srk-cover__block-body">\n',
    '            <p>', h(params$consultant$name), '</p>\n',
    consult_addr, '\n',
    '            <p><a href="', h(params$consultant$web), '">', h(params$consultant$web), '</a></p>\n',
    '          </div>\n',
    '        </section>'
  )

  # Roles (report uses Lead Author + Reviewer)
  report_labels <- c("Lead Author", "Reviewer")
  role_rows <- vapply(params$roles, function(r) {
    if (!r$label %in% report_labels) return("")
    paste0(
      '        <div class="srk-cover__role-row">\n',
      '          <div class="srk-cover__role-label">', h(r$label), ':</div>\n',
      '          <div class="srk-cover__role-value">', h(r$name), ', ', h(r$title), '</div>\n',
      '          <div class="srk-cover__role-label">Initials:</div>\n',
      '          <div class="srk-cover__role-value">', h(r$initials), '</div>\n',
      '        </div>'
    )
  }, character(1))
  role_rows <- role_rows[nzchar(role_rows)]
  roles_html <- paste(role_rows, collapse = "\n")

  # Citation
  citation_text <- build_citation(params)
  citation_html <- paste0(
    '        <div class="srk-cover__meta-item srk-cover__meta-item--citation">\n',
    '          <div class="srk-cover__meta-label">How to cite:</div>\n',
    '          <div class="srk-cover__meta-value">\n',
    '            ', citation_text, '\n',
    '          </div>\n',
    '        </div>'
  )

  # Assemble
  html <- paste0(
    '<section class="srk-cover">\n',
    '  <div class="srk-cover__layout">\n',
    '    <div class="srk-cover__content">\n',
    '      <div class="srk-cover__title-group">\n',
    '        <div class="srk-cover__kicker">', h(site_location), '</div>\n',
    '        <div class="srk-cover__project">\n',
    project_lines, '\n',
    '        </div>\n',
    '      </div>\n',
    '      <div class="srk-cover__blocks">\n',
    client_block, '\n',
    consultant_block, '\n',
    '      </div>\n',
    '      <div class="srk-cover__roles">\n',
    roles_html, '\n',
    '      </div>\n',
    '      <div class="srk-cover__meta">\n',
    citation_html, '\n',
    '      </div>\n',
    '    </div>\n',
    '  </div>\n',
    '</section>'
  )

  html
}

# -- PPT cover (Markdown) ----------------------------------------------
build_cover_ppt <- function(params) {
  title <- params$title
  subtitle <- paste0(params$site, ". ", params$location)

  role_lines <- vapply(params$roles, function(r) {
    paste0(
      r$label, ": ", r$name, ". ", r$title,
      ' <a href="mailto:', r$email, '"><i class="fa fa-envelope"></i></a>'
    )
  }, character(1))

  md <- paste0(
    '::: {.coverSlide}\n',
    '\n',
    '# ', title, '<br>', subtitle, ' {.cover-title}\n',
    '\n',
    '<p class="cover-authors" markdown="1">\n',
    'Project ID: ', params$project_id, '<br>\n',
    'Client: ', params$client$name, '<br>\n',
    paste0(role_lines, '<br>', collapse = "\n"), '\n',
    '\n',
    '</p>\n',
    '\n',
    ':::'
  )

  md
}

# nolint end
