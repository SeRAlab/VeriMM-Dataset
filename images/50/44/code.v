module top_module(Q, D, CLK, RST);output 	Q;
  input		D, CLK, RST;
  reg 		Q;

  always @ (posedge CLK, negedge RST)	
    if (RST == 0) Q <= 1'b0;
    else Q <= D;endmodule