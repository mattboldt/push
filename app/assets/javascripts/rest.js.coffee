
$ ->

  $("#git-create-repo").click (e) ->
    e.preventDefault()
    repo_name = $("#git-repo-name").val()
    params =
      repo: repo_name
    $.ajax
      type: "POST"
      url: "/rest/git-repo-setup"
      data: params
      success: (data) ->
        $(".result").html(data)
      failure: (data) ->
        $(".result").html("Something went wrong")


  createRepo: (data) ->




  restCall: (type, url, data) ->
    $.ajax
      url: url
      data: data
      success: (data) ->
        return data
      failure: (data) ->
        return data
