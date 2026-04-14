module register_with_reset (
	input clk,
	input reset,
	input [7:0] data,
	output [7:0] q);reg [7:0] reg_data = 8'b00000000;

	always @(posedge clk) begin
		if (reset)
			reg_data <= 8'b00000000;
		else
			reg_data <= data;
	end
	
	assign q = reg_data;
	
endmodule