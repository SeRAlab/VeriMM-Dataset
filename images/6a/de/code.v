module top_module(A, B, C, D, E, valid);wire _0_;
  wire _1_;
  wire _2_;
  (* src = "var5_multi.v:3" *)
  input A;
  (* src = "var5_multi.v:3" *)
  input B;
  (* src = "var5_multi.v:3" *)
  input C;
  (* src = "var5_multi.v:3" *)
  input D;
  (* src = "var5_multi.v:3" *)
  input E;
  (* src = "var5_multi.v:10" *)
  wire [6:0] total_value;
  (* src = "var5_multi.v:4" *)
  output valid;
  assign _0_ = D & E;
  assign _1_ = B | A;
  assign _2_ = ~(_1_ | C);
  assign valid = _2_ & _0_;
  assign total_value[1:0] = { E, C };
endmodule