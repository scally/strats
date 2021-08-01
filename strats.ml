open Base
open Opium

let show_config_handler _ =
  let config = Config.parse() in
  Response.of_json (
    `Assoc
    [
      ("Seed", `Int config.seed );
      ("Candidates", `List (config.candidates |> List.map ~f:(fun c -> `String c)))
    ]
  )
  |> Lwt.return

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
  |> App.get "/config" show_config_handler
  |> App.get "/liveness" liveness_handler
  |> App.run_command

