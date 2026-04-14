module top_module(
    input clk,
    input rst,
    input [7:0] A,
    input [7:0] B,
    output reg [8:0] result,
    output reg overflow
);always @(posedge clk) begin
        if (!rst) begin
            result <= 0;
            overflow <= 0;
        end else begin
            result <= A + B;
            overflow <= (result > 8'b11111111);
        end
    end

endmodule