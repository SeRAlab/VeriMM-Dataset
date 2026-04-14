module top_module(
	input clk,             
	input rst,             
	input [15:0] range,
	output reg [15:0] value
);always @(posedge clk or posedge rst)
    begin
        if (rst) value <= 0;
        else if (value == range - 1) value <= 0;
        else value <= value + 1;
    end

endmodule