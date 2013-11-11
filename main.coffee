do ($=jQuery)->
  $.getUrlParam = (key)->
    result = new RegExp("#{key}=([^&]*)", "i").exec(window.location.search)
    return result and unescape(result[1]) or ""

addSigners = (data) ->
  for s in data.signers
    $li = $("<li><img src='#{s.picture_url}' alt='#{s.name}' title='#{s.name}' /></li>")
    $('ul.signers').append($li)

APP_HOST = "http://stand-with-todd.herokuapp.com"

SPECIAL_SIGNERS = [
  name: 'Aneesh Chopra'
  picture_url: 'https://pbs.twimg.com/profile_images/378800000040581867/a0962f4551be12d095b281f8afa81a95.jpeg'
,
  name: "Tim O'Reilly"
  picture_url: 'https://pbs.twimg.com/profile_images/2823681988/f4f6f2bed8ab4d5a48dea4b9ea85d5f1.jpeg'
,
  name: 'Adam Becker'
  picture_url: 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash1/211991_1032810376_1446025_n.jpg'
,
  name: 'Clay Johnson'
  picture_url: 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-ash2/1118362_500311166_1359454261_n.jpg'
,
  name: 'Mike Aleo'
  picture_url: 'https://fbcdn-profile-a.akamaihd.net/hprofile-ak-prn2/1118049_15209525_1211909952_n.jpg'
]

$ ->
  if $.getUrlParam('signed')
    $('h1.signed').show()
    $('h1.not-signed').hide()

  addSigners(signers: SPECIAL_SIGNERS)

  initialSkip = 20 - SPECIAL_SIGNERS.length

  $.getJSON "#{APP_HOST}?limit=#{initialSkip}", (data) ->
    $('.signers-count').text(data.count)
    addSigners(data)

  skip = initialSkip
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
