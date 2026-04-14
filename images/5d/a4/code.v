module top_module(
output reg [size-1:0]	q,
input [size-1:0]	d,
input clk
);parameter size = 128;

always @(posedge clk) begin
	   q <= d;
end

endmodule