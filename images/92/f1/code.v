module up_down_counter (
	input clk,
	input resetn,
	input up,
	output reg [3:0] count);

	always @(posedge clk) begin
		if (~resetn) count <= 4'b0000;
		else if (up) count <= count + 1;
		else count <= count - 1;
	end
endmodule