rabbitmq-mailgun worker
------------------------

This is a quick tool I built to offload some automated email tasks
(password resets/invites/etc.) to external worker processes.

## Environment

This app is intended to be deployed to something like Heroku/Nodejitsu/etc.

As such, all of the primary configuration is provided via environmental variables:

### RMG_AMPQ_SERVER - RabbitMQ [connection string](http://www.rabbitmq.com/uri-spec.html)
example: 'amqp://user:password@host/instance'

    server = process.env.RMG_AMQP_SERVER


### RMG_AMPQ_QUEUE - Queue name to subscribe to. 
example: 'reset_requests'

    queue = process.env.RMG_AMQP_QUEUE


### RMG_MG_KEY - Mailgun [API key](http://documentation.mailgun.com/quickstart.html#authentication):
example: 'key-1234567890abcdef'

    mailgun_api_key = process.env.RMG_MG_KEY


## Additional configuration

Defaults for all of the email properties may be provided in this configuration object:

    config =
      sender  : 'Default Sender <noreply@myapp.com>'
      subject : 'A message from Default Sender'

      

This will be overridden by environmental variables if they're defined. The rationale being,
you should be able to deploy the base `npm install rabbitmq-mailgun` without modifying the code.

These optinal environmental variables are:

- RMG_SENDER: The 'From' field
- RMG_RECIPIENT: The 'to' field
- RMG_SUBJECT: The 'subject' filed
- RMG_BODY: 'The email msg body'


Grab Underscore:

    _ = require 'underscore'

Connect to our RabbitMQ instance:

    context = require('rabbit.js').createContext(server)


Create an instance of our mailgun client:

    {Mailgun} = require 'mailgun'

    mail = new Mailgun(mailgun_api_key)


Construct a Mailer class...

    class Mailer
      constructor: (options) ->

Set reasonable defaults...

        _.defaults options,
          sender    : if process.env.RMG_SENDER then process.env.RMG_SENDER else config.sender
          recipient : if process.env.RMG_RECIPIENT then process.env.RMG_RECIPIENT else config.recipient
          subject   : if process.env.RMG_SUBJECT then process.env.RMG_SUBJECT else config.subject
          body      : if process.env.RMG_BODY then process.env.RMG_BODY else config.body
          

        {sender,recipient,subject, body} = options

and fire off our message:

        mail.sendText sender, recipient, subject, body, (err) ->

In production, I'm firing these off to our monitoring system.

          if err then console.log err


Our RabbitMQ listener:

    context.on 'ready', ->
      console.log new Date() + '- Connected to AMQP server'
      sub = context.socket 'SUB'
      sub.connect queue

When a new msg hits the queue, spin up a new Mailer instance and pass the contents:

      sub.on 'data', (data) ->
        msg = JSON.parse data
        new Mailer msg
