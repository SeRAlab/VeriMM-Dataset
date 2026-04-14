module shiftreg4bit(
	input clk,
	input rst,
	input din,
	output reg [3:0] dout);always @(posedge clk or posedge rst) begin
		if (rst)
			dout <= 4'b0000;
		else
			dout <= {dout[2:0], din};
	end
	
endmodule