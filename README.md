# NOTE - Literate coffeescript is one of the worst ideas ever. I have no idea why I ever did this. It is unmaintainable garbage. Leaving this here as a testament to poor decisions. 


rabbitmq-mailgun
===

This is a quick tool I built to offload password reset/invite/whatever emails to an outside worker process.


### Diagram

![figure 1](https://raw.github.com/markhuge/rabbitmq-mailgun/master/docs/fig1.png)

### Environmental Variables

The app expects several environmental variables to be set in order to connect to resources:

 Variable | Description 
---|----
RMG_AMPQ_SERVER | RabbitMQ [connection string](http://www.rabbitmq.com/uri-spec.html) 
RMG_AMPQ_QUEUE | [queue](http://www.rabbitmq.com/amqp-0-9-1-quickref.html#class.queue) name to subscribe to 
RMG_MG_KEY | Mailgun [API key](http://documentation.mailgun.com/quickstart.html#authentication) 

