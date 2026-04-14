module top_module(
  output reg	enable_DP,
  input		enable, clk, rst
);reg [2:0] cylces;
parameter BeginCycle=0, EndCycle=2;

  always @(posedge clk)
    if (rst == 1) enable_DP <=0;
	 else if (cylces==EndCycle) enable_DP<=1;
	 else enable_DP<=0;
	 
always@(posedge clk)
	if (rst==1) cylces<=0;
	else 
	case (enable)
	0: cylces<=cylces;
	1: if(cylces<EndCycle) cylces<=cylces+1;
	else cylces<=BeginCycle;
	endcase
    
endmodule