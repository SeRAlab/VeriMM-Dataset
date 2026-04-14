module top_module(ctrl, D0, D1, D2, D3, S);input [1:0] ctrl;
  input [7:0] D0;
  input [7:0] D1;
  input [7:0] D2;
  input [7:0] D3;
  output [7:0] S;

  assign S = (ctrl == 2'b00) ? D0 :
             (ctrl == 2'b01) ? D1 :
             (ctrl == 2'b10) ? D2 :
             (ctrl == 2'b11) ? D3 :
             8'b0;
endmodule