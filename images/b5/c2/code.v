module register(
	input clk,
	input reset,
	input enable,
	input [15:0] data,
	output reg [15:0] q);always @(posedge clk) begin
    if (reset)
        q <= 16'b0000000000000000;
    else if (enable)
        q <= data;
end
endmodule