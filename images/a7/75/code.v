module top_module(r, s, q);wire _0_;
  wire _1_;
  (* src = "/Users/tramyn/Documents/workspaces/cello_workspace/yosysRun/srlatch.v:8" *)
  output q;
  (* src = "/Users/tramyn/Documents/workspaces/cello_workspace/yosysRun/srlatch.v:6" *)
  input r;
  (* src = "/Users/tramyn/Documents/workspaces/cello_workspace/yosysRun/srlatch.v:7" *)
  input s;
  assign _1_ = ~(r | _0_);
  assign _0_ = ~(s | _1_);
  assign q = ~_0_;
endmodule