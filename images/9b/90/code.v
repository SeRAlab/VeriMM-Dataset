module register(
	input clk,
	input reset,
	input enable,
	input [31:0] data,
	output reg [31:0] q);always @(posedge clk) begin
    if (reset)
        q <= 32'b00000000000000000000000000000000;
    else if (enable)
        q <= data;
end
endmodule