module johnson_counter (
	input clk,
	input reset,
	output reg [9:0] count);

	always @(posedge clk) begin
		if (reset)
			count <= 10'b0000000000;
		else
			count <= {~count[0], count[9:1]};
	end
	
endmodule