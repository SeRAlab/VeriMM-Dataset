module down_counter (
	input clk,
	output reg [2:0] count);initial
		count = 3'b111;
		
	always @(posedge clk) begin
		count <= count - 1;
	end

endmodule