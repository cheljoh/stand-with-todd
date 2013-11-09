addSigners = (data) ->
  for s in data.signers
    $('ul.signers').append("<li><img src='#{s.picture_url}' /></li>")

$ ->
  $.getJSON 'http://localhost:3000', (data) ->
    addSigners(data)

    $('.signers-count').text(data.count)

    if data.signed
      $('h1.signed').show()
      $('h1.not-signed').hide()

  skip = 10
  loading = false

  $('a.load-more').click ->
    return if loading
    loading = true
    $(@).data('original-text', $(@).text())
    $(@).text('Loading...')

    $.getJSON "http://localhost:3000/more?skip=#{skip}", (data) =>
      addSigners(data)
      skip = skip + data.signers.length
      loading = false
      $(@).text($(@).data('original-text'))
