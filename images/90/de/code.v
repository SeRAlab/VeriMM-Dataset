module top_module(
    output reg [3:0] sum,
    input [3:0] a,
    input [3:0] b,
    input cin,
    input clk,
    input reset
);always @(posedge clk) begin
        if (reset) begin
            sum <= 4'b0000;
        end else begin
            sum <= a + b + cin;
        end
    end

endmodule