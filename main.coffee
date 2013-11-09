`(function($){
  $.getUrlParam = function(key){
    var result = new RegExp(key + "=([^&]*)", "i").exec(window.location.search);
    return result && unescape(result[1]) || "";
  };
})(jQuery);`

addSigners = (data) ->
  for s in data.signers
    $li = $("<li><img src='#{s.picture_url}' alt='#{s.name}' title='#{s.name}' /></li>")
    $img = $li.find('img')
    $('ul.signers').append($li)
    $img.height($img.width())

$ ->
  if $.getUrlParam('signed')
    $('h1.signed').show()
    $('h1.not-signed').hide()

  $.getJSON 'http://stand-with-todd.herokuapp.com', (data) ->
    addSigners(data)

    $('.signers-count').text(data.count)

  skip = 10
  loading = false

  $('a.load-more').click ->
    return if loading
    loading = true
    $(@).data('original-text', $(@).text())
    $(@).text('Loading...')

    $.getJSON "http://stand-with-todd.herokuapp.com/more?skip=#{skip}", (data) =>
      addSigners(data)
      skip = skip + data.signers.length
      loading = false
      $(@).text($(@).data('original-text'))

  $(window).on 'resize', ->
    $('ul.signers img').each ->
      $(@).css('height': '')
      $(@).height($(@).width())
