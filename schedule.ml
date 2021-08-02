let shuffle candidates =
  candidates 
  |> List.sort (fun _ _ -> Random.int 2)

let build_year candidates = 
  let s = ref [] in
  while List.length !s < 365 do
    s := !s @ shuffle candidates
  done;
  !s

module T = Map.Make(String)
let all_schedules = 
  let open Config in
  let s = ref T.empty in
  let { seed; candidates } = parse() in
  let _ = Random.init seed in
  let _ = s := T.add "main" (build_year candidates) !s in
  let _ = List.iter (fun c -> 
    let without = List.filter (fun innerC -> innerC != c) candidates in
    let _ = s := T.add c (build_year without) !s in
    ()
    ) candidates in
  !s

let main_schedule = T.find "main" all_schedules

let day schedule n = List.nth schedule n

let day_with_alternative n =
  let candidate = day main_schedule n in
  let alternative = day (T.find candidate all_schedules) n in
  (candidate, alternative)
