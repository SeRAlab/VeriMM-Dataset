module top_module(A, out);(* src = "f3m.v:573" *)
  input [195:0] A;
  (* src = "f3m.v:574" *)
  output [195:0] out;
  assign out = { A[193:0], 2'h0 };endmodule