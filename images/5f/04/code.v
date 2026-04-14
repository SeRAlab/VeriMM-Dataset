module shift_register16bit_tc (
	input clk,
	input rst,
	input load,
	input [15:0] load_val,
	output reg [15:0] q,
	output tc);

	always @(posedge clk or posedge rst) begin
		if (rst)
			q <= 16'b0000000000000000;
		else if (load)
			q <= load_val;
		else
			q <= {q[14:0], 1'b0};
	end
	
	assign tc = q[15];
	
endmodule