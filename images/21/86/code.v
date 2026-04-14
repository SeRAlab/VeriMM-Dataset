module IIR_Filter #(parameter a = 16'h1, parameter b = 16'h1) (
    input clk,
    input rst,
    input [15:0] x,
    output reg [15:0] y
);
    reg [15:0] prev_y;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            y <= 16'h0;
            prev_y <= 16'h0;
        end else begin
            y <= (a * x) + (b * prev_y);
            prev_y <= y;
        end
    end
endmodule