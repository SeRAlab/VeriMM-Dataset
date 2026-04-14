module top_module(
    input clk,
    input rst,
    input [7:0] a,
    input [7:0] b,
    input op,
    output reg [7:0] result
);always @(posedge clk, posedge rst) begin
    if (rst) begin
        result <= 0;
    end else begin
        if (op == 0) begin
            result <= a + b;
        end else begin
            result <= a - b;
        end
    end
end

endmodule