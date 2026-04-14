module top_module(
    input clk,
    input reset,
    input shift,
    input data_in,
    output reg [7:0] q);always @(posedge clk, posedge reset) begin
		if (reset)
			q <= 0;
		else if (shift)
			q <= {q[6:0], data_in};
	end
endmodule