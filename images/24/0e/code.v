module DWT (
    input wire clk,
    input wire rst,
    input wire valid,
    input wire [15:0] x0,
    input wire [15:0] x1,
    input wire [15:0] x2,
    input wire [15:0] x3,
    output reg [15:0] a0,
    output reg [15:0] d0
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            a0 <= 16'b0;
            d0 <= 16'b0;
        end else if (valid) begin
            a0 <= (x0 + x1 + x2 + x3) >> 1; // Division by 2
            d0 <= (x0 - x1 + x2 - x3) >> 1; // Division by 2
        end
    end
endmodule