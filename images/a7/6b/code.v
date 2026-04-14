module top_module(ctrl,
   D0,
   D1,
   D2,
   D3,
   S);input [1:0]ctrl;
  input D0;
  input D1;
  input D2;
  input D3;
  output S;

  wire S1;
  wire S2;

  assign S1 = (ctrl[0] == 1'b0) ? D0 : D1; // First level multiplexer
  assign S2 = (ctrl[0] == 1'b0) ? D2 : D3; // Second level multiplexer
  assign S = (ctrl[1] == 1'b0) ? S1 : S2; // Final output selection

endmodule