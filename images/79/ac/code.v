module top_module(clk, rst, q);input clk, rst;
output reg [3:0] q;

always @(posedge clk) begin
	if (rst == 1'b1) // Synchronous reset
		q <= 4'b0;
	else if (q == 4'b1111) // Counter rolls over to 0
		q <= 4'b0;
	else
		q <= q + 1; // Counter increments
end

endmodule