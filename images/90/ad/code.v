module top_module(clk, d, rst, q);input clk, rst;
    input [7:0] d;
    output [7:0] q;
    reg [7:0] q;

    always @(posedge clk) begin
        if (rst) begin
            q <= 8'b0;
        end else begin
            q <= d;
        end
    end
endmodule