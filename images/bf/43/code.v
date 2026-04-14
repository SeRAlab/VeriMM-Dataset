module bcd_counter (
	input clk,
	input reset,
	output reg [11:0] count);

	always @(posedge clk) begin
		if (reset)
			count <= 12'b000000000000;
		else if (count == 12'b100110011001)
			count <= 12'b000000000000;
		else
			count <= count + 1;
	end
	
endmodule