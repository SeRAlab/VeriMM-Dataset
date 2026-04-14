module top_module(
    input clk,
    input [7:0] in,
    output reg [7:0] out
);always @(posedge clk) begin
        out[7:1] <= in[6:0];
        out[0] <= 1'b0;
    end

endmodule