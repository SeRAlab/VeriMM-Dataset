module parallel_load_shift_register(
	input clk,
	input rst,
	input load,
	input [7:0] data,
	output reg [7:0] q
);

	always@(posedge clk or posedge rst) begin
		if(rst)
			q <= 8'b00000000;
		else if(load)
			q <= data;
		else
			q <= {1'b0, q[7:1]};
	end
	
endmodule