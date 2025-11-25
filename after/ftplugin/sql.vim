if get(g:, 'db_ui_disable_mappings', 0) || get(g:, 'db_ui_disable_mappings_sql', 0)
  finish
endif

if exists('*db_ui#utils#set_mapping')
  call db_ui#utils#set_mapping('<Leader>S', 'vis<Plug>(DBUI_ExecuteQuery)')
endif
