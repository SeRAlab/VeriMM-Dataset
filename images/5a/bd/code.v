module top_module( clk, ld, d, rst, q );input clk;
    input ld;
    input rst;
    input [63:0] d;
    output [63:0] q;
    reg [63:0] q;

    always @(posedge clk) begin
        if (rst) begin
            q <= 0;
        end else if (ld) begin
            q <= d;
        end
    end
endmodule