module top_module(
    input clk,
    input clear,
    output reg [3:0] q);always @(posedge clk or posedge clear) begin
		if (clear)
			q <= 4'b0;
		else
			q <= {q[2:0], ~q[3]};
	end
endmodule