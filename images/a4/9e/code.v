module my_module (
	input clk,
	input enable, 
	output reg [2:0] out);always @(posedge clk)
		if (enable)
			out <= (out == 7) ? 3 : out + 1;
		else
			out <= out;

endmodule