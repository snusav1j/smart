$ ->
  $(document).on 'click', '.p2p-header', (e) ->
    hide_show_btn = $(this).find('.hide-show-card')
    p2p_card_body = $(this).parents('.p2p-card').find('.p2p-info')

    hide_show_btn.toggleClass('rotated')
    p2p_card_body.stop(true, true).slideToggle(200)

  # $(document).on 'change', '#p2p_p2p_type', (e) ->
  #   p2p_type = $(this).val()
  #   if p2p_type == '0'
  #     $('.p2p-form-buy').show()
  #     $('.p2p-form-sell').hide()
  #     $('input#p2p_buy_order_number').val('')
  #   else
  #     $('.p2p-form-buy').hide()
  #     $('.p2p-form-sell').show()
  #     $('input#p2p_sell_order_number').val('')

  # Динамическое добавление файлов
  $(document).on 'click', '#add-file-link', (e) ->
    e.preventDefault()
    filesContainer = $('#files-container')
    firstUpload = filesContainer.find('.file-upload').first()
    return unless firstUpload.length

    clone = firstUpload.clone()

    # Очистить значения и уникализировать индексы
    clone.find('input').each (i, input) ->
      $input = $(input)
      $input.val('')

      name = $input.attr('name')
      if name
        newName = name.replace(/\[\d+\]/, "[#{Date.now()}]")
        $input.attr('name', newName)

    # Добавляем кнопку удаления к клону
    unless clone.find('.remove-file-btn').length
      removeBtn = $('<a href="#" class="remove-file-btn" style="margin-left: 10px; font-size: 0.85em;">Удалить</a>')
      clone.append(removeBtn)

    filesContainer.append(clone)

  # Удаление файла перед сабмитом
  $(document).on 'click', '.remove-file-btn', (e) ->
    e.preventDefault()
    $(this).closest('.file-upload').remove()


  # Удаление существующих файлов через AJAX
  $(document).on 'click', '.delete-file', (e) ->
    e.preventDefault()
    fileId = $(this).data('file_id')
    p2pId = $(this).data('p2p_id')  # передаём id P2P через data
    link = $(this)
    if fileId and p2pId
      $.ajax
        url: "/p2ps/#{p2pId}/file_destroy/#{fileId}"
        type: "DELETE"
        dataType: "json"
        success: (resp) ->
          link.closest('.file-upload').remove()
        error: (err) ->
          alert("Ошибка при удалении файла")
