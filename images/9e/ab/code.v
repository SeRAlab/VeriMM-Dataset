module top_module(A, B, C, D, E, valid);wire _0_;
  wire _1_;
  wire _2_;
  (* src = "single.v:3" *)
  input A;
  (* src = "single.v:3" *)
  input B;
  (* src = "single.v:3" *)
  input C;
  (* src = "single.v:3" *)
  input D;
  (* src = "single.v:3" *)
  input E;
  (* src = "single.v:9" *)
  wire [4:0] total_value;
  (* src = "single.v:4" *)
  output valid;
  assign _0_ = E & C;
  assign _1_ = ~(B & D);
  assign _2_ = ~(_1_ | A);
  assign valid = _2_ & _0_;
  assign total_value[0] = D;
endmodule