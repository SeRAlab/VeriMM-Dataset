module loadable_counter (
	input clk,
	input reset,
	input load,
	input [11:0] load_value,
	output reg [11:0] count);

	always @(posedge clk) begin
		if (reset)
			count <= 12'b000000000000;
		else if (load)
			count <= load_value;
		else
			count <= count + 1;
	end
	
endmodule