module shift_register (
	input clk,
	input reset,
	input [2:0] data_in,
	output reg [2:0] q);

	always @(posedge clk) begin
		if (reset) q <= 3'b000;
		else q <= {data_in[2], q[2:1]};
	end
	
endmodule