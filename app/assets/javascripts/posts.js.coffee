$ ->
  setTimeout (->
    source = new EventSource("/posts/live")
    source.addEventListener "refresh", (e) ->
      data = $.parseJSON(e.data)
      console.log data
      $('.time').text(data.time)
  ), 1
