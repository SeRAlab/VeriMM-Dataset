module binary_counter (
	input clk,
	input reset_n,
	input enable,
	output reg [2:0] count);

	always @(posedge clk or negedge reset_n) begin
		if (!reset_n) count <= 3'b000;
		else if (enable) count <= count + 1;
	end
	
endmodule