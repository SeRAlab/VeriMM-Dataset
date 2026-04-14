module preset_reg (
	input clk,
	input preset,
	input d,
	output reg q);always @(posedge clk or posedge preset)
	if (preset)
		q <= 1;
	else
		q <= d;
		
endmodule