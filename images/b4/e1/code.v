module counter_with_load_enable (
	input clk,
	input reset,
	input load,
	input enable,
	input [31:0] data,
	output reg [31:0] count);

	always @(posedge clk) begin
		if (reset)
			count <= 32'b00000000000000000000000000000000;
		else if (load)
			count <= data;
		else if (enable)
			count <= count + 1;
	end
	
endmodule