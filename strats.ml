open Opium

let liveness_handler _ =
  Response.of_json (
    `Assoc
    [
      ("Ok", `String "Ok")
    ]
  )
  |> Lwt.return

let _ = 
  App.empty 
  |> App.get "/liveness" liveness_handler
  |> App.run_command

