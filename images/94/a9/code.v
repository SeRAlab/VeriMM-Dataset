module down_counter(
	input clk,
	input clr,
	input ena,
	output reg [3:0] q);
always @(negedge clk) begin
		if (clr)
			q <= 4'b0;
		else if (ena)
			q <= q - 1;
	end
endmodule