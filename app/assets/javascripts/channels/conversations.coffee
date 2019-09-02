jQuery(document).on 'turbolinks:load', ->
  messages_to_bottom = -> messages.scrollTop(messages.prop("scrollHeight"))
  messages = $('#conversation-body')
  $new_message_form = $('#new-message')
  $new_message_attachment = $new_message_form.find('#message-attachment')

  if $('#current-user').size() > 0
    App.personal_chat = App.cable.subscriptions.create {
      channel: "NotificationsChannel"
    },
      connected: ->
# Called when the subscription is ready for use on the server

      disconnected: ->
# Called when the subscription has been terminated by the server

      received: (data) ->
        if messages.size() > 0 && messages.data('conversation-id') is data['conversation_id']
          messages.append data['message']
          messages_to_bottom()
        else
          $.getScript('/conversations') if $('#conversations').size() > 0
          $('body').append(data['notification']) if data['notification']

      send_message: (message, conversation_id , file_uri, original_name) ->
        @perform 'send_message', message: message, conversation_id: conversation_id, file_uri: file_uri, original_name: original_name

  $(document).on 'click', '#notification .close', ->
    $(this).parents('#notification').fadeOut(1000)

  if messages.length > 0
    messages_to_bottom()
    $('#new_personal_message').submit (e) ->
      $this = $(this)
      textarea = $this.find('#personal_message_body')
      if $.trim(textarea.val()).length > 0 or $new_message_attachment.get(0).files.length > 0
        if $new_message_attachment.get(0).files.length > 0
          reader = new FileReader()
          file_name = $new_message_attachment.get(0).files[0].name
          reader.addEventListener "loadend", ->
            App.personal_chat.send_message textarea.val(), reader.result, file_name, $this.find('#conversation_id').val()
          reader.readAsDataURL $new_message_attachment.get(0).files[0]
        else
          App.personal_chat.send_message textarea.val(), $this.find('#conversation_id').val()
          textarea.val('')
      e.preventDefault()
      return false