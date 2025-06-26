let make = async () => {
  let worker = MSW.setupWorker()
  await MSW.ServiceWorker.startWithOptions(
    worker,
    {
      onUnhandledRequest: #bypass,
      serviceWorker: {
        options: {
          scope: "/api/",
        },
      },
    },
  )
}
