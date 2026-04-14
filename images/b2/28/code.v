module top_module(
    input clk,
    input reset,
    input load,
    input [3:0] data_in,
    output reg [3:0] q);always @(posedge clk, posedge reset) begin
		if (reset)
			q <= 4'b0000;
		else if (load)
			q <= data_in;
	end
endmodule