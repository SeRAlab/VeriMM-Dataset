module top_module( clk, d, rst, q );input clk, rst;
    input [63:0] d;
    output [63:0] q;
    reg [63:0] q;

    always @(posedge clk or negedge rst) begin
        if (rst == 0) begin
            q <= 0;
        end else begin
            q <= d;
        end
    end

endmodule