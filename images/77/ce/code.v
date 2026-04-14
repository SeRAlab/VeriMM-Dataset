module top_module(
    input clk,
    input reset,
    input load,
    input ena,
    input [7:0] data,
    output reg [7:0] q);always @(posedge clk or posedge reset) begin
		if (reset)
			q <= 0;
		else if (load)
			q <= data;
		else if (ena)
			q <= {1'b0, q[7:1]};
	end
endmodule