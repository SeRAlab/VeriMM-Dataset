module top_module(
    input clk,
    input reset,
    input enable,
    output reg [3:0] q);always @(posedge clk, posedge reset) begin
		if (reset)
			q <= 0;
		else if (enable)
			q <= {~q[3], q[3:1]};
	end
endmodule