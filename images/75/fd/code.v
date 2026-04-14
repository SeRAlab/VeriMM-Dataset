module up_down_counter (
	input clk,
	input rst,
	input dir,
	output reg [7:0] count);

	always @(posedge clk) begin
		if (rst)
			count <= 8'b00000000;
		else if (dir)
			count <= count + 1;
		else
			count <= count - 1;
	end
	
endmodule