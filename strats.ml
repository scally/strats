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

let show_schedule_handler _ =
  Response.of_json (
    `Assoc
    [
      ("Schedule", `List (Schedule.main_schedule |> List.map ~f:(fun c -> `String c)))
    ]
  )
  |> Lwt.return

let show_day_handler req = 
  let (candidate, alternative) = 
    Router.param req "day"
    |> Int.of_string
    |> Schedule.day_with_alternative in
  Response.of_json (
    `Assoc
    [
      ("Today", `String candidate);
      ("Alternative", `String alternative)
    ]
  )
  |> Lwt.return

let show_today_handler _ =
  let today = 
    Unix.time()
    |> Unix.localtime in
  let (candidate, alternative) = 
    Schedule.day_with_alternative today.tm_yday in
  Response.of_json (
    `Assoc
    [
      ("Today", `String candidate);
      ("Alternative", `String alternative)
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
  |> App.get "/today" show_today_handler
  |> App.get "/day/:day" show_day_handler
  |> App.get "/schedule" show_schedule_handler
  |> App.get "/config" show_config_handler
  |> App.get "/liveness" liveness_handler
  |> App.run_command

