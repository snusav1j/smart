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
