module top_module(sw, ca, cb, cc, cd, ce, cf, cg, dp, an, led);input [15:0] sw;                          
	output ca, cb, cc, cd, ce, cf, cg, dp;  
	output [7:0] an;                          
	output [15:0] led;                        
	assign led = sw;
	assign {ca,cb,cc,cd,ce,cf,cg,dp} = ~sw[7:0];
	assign an = ~sw[15:8];
endmodule