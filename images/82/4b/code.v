module top_module(
input wire clk,
input wire [3:0] num_a,
input wire [3:0] num_b,
input wire ctrl,
output reg [3:0] out
);always @(posedge clk) begin
	if(ctrl == 0) begin
		out <= num_a + num_b;
	end
	else begin
		out <= num_a - num_b;
	end
end

endmodule