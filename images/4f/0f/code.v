module top_module(a, b, c, d);wire _0_;
  wire _1_;
  (* src = "/Users/tramyn/Documents/workspaces/cello_workspace/yosysRun/contAssign7.v:3" *)
  input a;
  (* src = "/Users/tramyn/Documents/workspaces/cello_workspace/yosysRun/contAssign7.v:3" *)
  input b;
  (* src = "/Users/tramyn/Documents/workspaces/cello_workspace/yosysRun/contAssign7.v:3" *)
  input c;
  (* src = "/Users/tramyn/Documents/workspaces/cello_workspace/yosysRun/contAssign7.v:4" *)
  output d;
  assign _0_ = ~(a | b);
  assign _1_ = ~_0_;
  assign d = ~(c | _1_);
endmodule