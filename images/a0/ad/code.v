module binary_counter_with_enable (
	input clk,
	input rst,
	input en,
	output reg [1:0] count);

	always @(posedge clk) begin
		if (rst)
			count <= 2'b00;
		else if (en)
			count <= count + 1;
	end
	
endmodule