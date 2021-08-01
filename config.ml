open Yojson.Basic

type t = {
  seed: int;
  candidates: string list;
}

let file = from_file "config.json" 
let parse () = 
  let open Util in
  let seed = file|> member "seed" |> to_int in 
  let candidates = file
  |> member "candidates" 
  |> to_list 
  |> filter_string in
  {
    seed;
    candidates;
  }