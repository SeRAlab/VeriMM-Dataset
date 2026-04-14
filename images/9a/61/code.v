module reg_with_enable (
    input clk,
    input reset,
    input enable,
    input [7:0] data,
    output reg [7:0] q);always @(posedge clk or posedge reset) begin
        if (reset) q <= 0;
        else if (enable) q <= data;
    end

endmodule