module binary_counter_with_clear (
	input clk,
	input clear,
	input enable,
	output reg [4:0] count);

	always @(posedge clk) begin
		if (clear)
			count <= 5'b00000;
		else if (enable)
			count <= count + 1;
	end
	
endmodule