module top_module(output reg [31:0] Y, input [31:0] I,
	input LE, CLR, CLK);always @ (posedge CLK, negedge CLR)

if (!CLR) 

    Y <= 32'h00000000; 

    else if ((LE == 0) && (CLK == 1)) 

    Y = I;endmodule