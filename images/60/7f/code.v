module top_module(
	input clk,
	input reset,
	input load,
	input [4:0] load_value,
	output reg [4:0] count);

always @(posedge clk) begin
		if (reset)
			count <= 5'b00001;
		else if (load)
			count <= load_value;
		else
			count <= {count[3:0], count[4]};
	end

endmodule