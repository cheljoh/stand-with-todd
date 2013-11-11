`(function($){
  $.getUrlParam = function(key){
    var result = new RegExp(key + "=([^&]*)", "i").exec(window.location.search);
    return result && unescape(result[1]) || "";
  };
})(jQuery);`

addSigners = (data) ->
  for s in data.signers
    $li = $("<li><img src='#{s.picture_url}' alt='#{s._id}' title='#{s._id}' /></li>")
    $('ul.signers').append($li)

APP_HOST = "http://localhost:3000"

$ ->
  if $.getUrlParam('signed')
    $('h1.signed').show()
    $('h1.not-signed').hide()

  $.getJSON "#{APP_HOST}?limit=10", (data) ->
    $('.signers-count').text(data.count)
    addSigners(data)

  skip = 10
  loading = false

  $('a.load-more').click ->
    return if loading
    loading = true
    $(@).data('original-text', $(@).text())
    $(@).text('Loading...')

    $.getJSON "#{APP_HOST}?skip=#{skip}", (data) =>
      addSigners(data)
      skip = skip + data.signers.length
      loading = false
      $(@).text($(@).data('original-text'))
