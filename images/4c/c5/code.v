module top_module(input [7:0] in0, in1, input  ctrl, output [7:0] out);reg [7:0] tmp;
		 always @*
				 tmp<= ctrl?in1:in0;
			 
		assign out = tmp;


endmodule