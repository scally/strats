module T = Map.Make(String)
let build_year candidates =
  Seq.unfold (fun days_left -> 
    let shuffle = List.sort (fun _ _ -> Random.int 2) in
    let next_count = days_left - (candidates |> List.length) in

    if next_count < 0 then
      None
    else
      Some (shuffle candidates, next_count)
    ) 366
  |> List.of_seq
  |> List.concat

let build_yearly () = 
  let open Config in
  let { seed; candidates } = Config.parse() in
  Random.init seed;
  candidates
  |> List.fold_left (fun m c -> 
    let without excluded = List.filter (fun i -> i != excluded) in
    let list_without_person = without c candidates in
    T.add c (build_year list_without_person) m
    ) (T.add "main" (build_year candidates) T.empty)

let day schedule n = List.nth schedule n

let main_schedule = T.find "main" (build_yearly())

let day_with_alternative n =
  let schedules = build_yearly() in
  let candidate = day main_schedule n in
  let alternative = day (T.find candidate schedules) n in
  (candidate, alternative)
