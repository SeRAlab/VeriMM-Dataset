module top_module(
    input clk,
    input reset,
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] product
);always @(posedge clk or posedge reset) begin
        if (reset) begin
            product <= 8'b0;
        end else begin
            product <= A * B;
        end
    end
endmodule