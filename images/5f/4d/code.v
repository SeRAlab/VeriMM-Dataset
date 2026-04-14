module up_counter(
	input clk,
	input reset,
	input enable,
	output reg [3:0] q);always @(posedge clk) begin
    if (reset)
        q <= 4'b0000;
    else if (enable)
        q <= q + 1;
end
endmodule