module top_module(pkti, we);(* src = "mkwe.v:1" *)
  input [9:0] pkti;
  (* src = "mkwe.v:1" *)
  output we;
  assign we = pkti[9] | pkti[8];endmodule