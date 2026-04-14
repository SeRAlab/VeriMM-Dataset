module top_module(
    input clk,
    input reset,
    input enable,
    input load,
    input [7:0] data,
    output reg [7:0] q);always @(negedge reset, posedge clk) begin
		if (!reset)
			q <= 0;
		else if (load)
			q <= data;
		else if (enable)
			q <= {q[6:0], 1'b0};
	end
endmodule