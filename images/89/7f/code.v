module top_module(ctrl, D0, D1, S);input [10:0] D0;
  input [10:0] D1;
  input ctrl;
  output [10:0] S;
  
  assign S = (ctrl == 0) ? D0 : D1;
  
endmodule