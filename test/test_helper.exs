alias UAInspector.Plug.TestHelpers.Retry

true = Retry.retry(5000, 10, &UAInspector.ready?/0, & &1)

ExUnit.start()
