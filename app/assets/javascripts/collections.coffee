$ ->
  input_type_select = $('#collection_import_type')
  folder_input = $('#collection_import_folder')
  display_import_type = ->
    if input_type_select.val() == 'folder'
      folder_input.parent().show()      
    else
      folder_input.parent().hide()      
  input_type_select.change ->
    display_import_type()
  display_import_type()