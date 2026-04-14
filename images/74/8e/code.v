module sync_reset_counter(
	input wire clk,
	input wire reset,
	output reg [2:0] count
);always @(posedge clk) begin
		if (reset)
			count <= 3'b000;
		else
			count <= count + 1;
	end
endmodule