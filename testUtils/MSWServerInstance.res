let server = MSW.setupServer()

MSW__Server.events(server)->MSW__Events.on(#unhandledException, ({requestId, _}) => {
  Js.Console.error(`response:mocked event for ${requestId}`)
})
