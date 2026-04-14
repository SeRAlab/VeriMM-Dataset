module top_module(
	input  wire clk,
	input  wire [3:0] data,
	output reg [3:0] q
    );always @(posedge clk) begin
		q <= data;
	end
endmodule