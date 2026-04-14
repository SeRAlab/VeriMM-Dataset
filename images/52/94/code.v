module top_module(Q, T, CLK, RST);output 	Q;
  input		T, CLK, RST;
  reg 		Q;

  always @ (posedge CLK, negedge RST)	
    if (~RST) Q <= 1'b0;
    else if (T) Q <= ~Q;endmodule