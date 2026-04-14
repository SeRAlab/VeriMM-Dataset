module top_module(CK,Q,D);input CK,D;
output Q;
reg Q;
always @ (posedge CK)
  Q <= D;endmodule