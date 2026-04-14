module top_module(A, B, valid);wire _0_;
  (* src = "grover_compare01.v:2" *)
  input A;
  (* src = "grover_compare01.v:2" *)
  input B;
  (* src = "grover_compare01.v:3" *)
  output valid;
  assign _0_ = ~A;
  assign valid = B & _0_;
endmodule