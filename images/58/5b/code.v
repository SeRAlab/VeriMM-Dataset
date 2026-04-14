module top_module(r, s, q);wire _0_;
  wire _1_;
  wire _2_;
  (* src = "/Users/tramyn/Documents/workspaces/cello_workspace/yosysRun/srlatch-synthesized.v:5" *)
  output q;
  (* src = "/Users/tramyn/Documents/workspaces/cello_workspace/yosysRun/srlatch-synthesized.v:3" *)
  input r;
  (* src = "/Users/tramyn/Documents/workspaces/cello_workspace/yosysRun/srlatch-synthesized.v:4" *)
  input s;
  assign _0_ = ~r;
  assign _1_ = ~s;
  assign _2_ = ~(_0_ & q);
  assign q = ~(_1_ & _2_);
endmodule