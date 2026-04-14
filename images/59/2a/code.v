module bcd_counter (
	input clk,
	input rst,
	output reg [3:0] bcd_count);

	always @(posedge clk) begin
		if (rst)
			bcd_count <= 4'b0000;
		else if (bcd_count == 4'b1001)
			bcd_count <= 4'b0000;
		else
			bcd_count <= bcd_count + 1;
	end
	
endmodule