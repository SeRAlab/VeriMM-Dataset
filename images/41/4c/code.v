module top_module(A, B, valid);(* src = "grover_compare00.v:2" *)
  input A;
  (* src = "grover_compare00.v:2" *)
  input B;
  (* src = "grover_compare00.v:3" *)
  output valid;
  assign valid = ~(B | A);
endmodule