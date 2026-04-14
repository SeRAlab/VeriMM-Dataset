module top_module(a, c);(* src = "f3.v:60" *)
  wire _0_;
  (* src = "f3.v:61" *)
  wire _1_;
  (* src = "f3.v:60" *)
  wire _2_;
  (* src = "f3.v:60" *)
  wire _3_;
  (* src = "f3.v:61" *)
  wire _4_;
  (* src = "f3.v:58" *)
  input [1:0] a;
  (* src = "f3.v:59" *)
  output [1:0] c;
  assign _0_ = _2_ & (* src = "f3.v:60" *) _3_;
  assign _1_ = a[0] & (* src = "f3.v:61" *) _4_;
  assign _2_ = ~ (* src = "f3.v:60" *) a[0];
  assign _3_ = ~ (* src = "f3.v:60" *) a[1];
  assign _4_ = ~ (* src = "f3.v:61" *) a[1];
  assign c[0] = _0_;
  assign c[1] = _1_;endmodule