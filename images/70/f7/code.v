module top_module(a, b, y);wire _0_;
  (* src = "/Users/tramyn/Documents/workspaces/cello_workspace/yosysRun/contAssign4.v:9" *)
  input a;
  (* src = "/Users/tramyn/Documents/workspaces/cello_workspace/yosysRun/contAssign4.v:10" *)
  input b;
  (* src = "/Users/tramyn/Documents/workspaces/cello_workspace/yosysRun/contAssign4.v:11" *)
  output y;
  assign _0_ = ~(a | b);
  assign y = ~_0_;
endmodule