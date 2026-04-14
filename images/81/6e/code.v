module top_module(
    input clk,
    input reset,
    input load,
    input ena,
    input [5:0] data,
    output reg [5:0] q);always @(posedge clk, posedge reset) begin
		if (reset)
			q <= 0;
		else if (load)
			q <= data;
		else if (ena)
			q <= {q[4:0], q[5]};
	end
endmodule