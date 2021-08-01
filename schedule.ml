let create seed candidates =
  let _ = Random.init seed in
  candidates 
  |> List.sort (fun _ _ -> Random.int 2)

let schedule = 
  let open Config in
  let { seed; candidates } = parse() in
  (* reducer, accumulator, list *)
  let s = ref [] in
  while List.length !s < 365 do
    s := !s @ create seed candidates
  done;
  !s