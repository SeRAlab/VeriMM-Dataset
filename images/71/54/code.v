module top_module(
    input clk,
    input reset,
    input enable,
    input load,
    input [3:0] data,
    output reg [3:0] q);always @(posedge clk, posedge reset) begin
		if (reset)
			q <= 4'b0001;
		else if (load)
			q <= data;
		else if (enable)
			q <= {q[0], q[3:1]};
	end
endmodule