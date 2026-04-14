module ecc_point_doubling(
    input clk,
    input reset,
    input [15:0] x1,
    input [15:0] y1,
    output reg [15:0] x3,
    output reg [15:0] y3
);
    parameter [15:0] a = 16'h0001; // a constant for the curve
    reg [15:0] lambda;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x3 <= 16'h0000;
            y3 <= 16'h0000;
        end else begin
            // Calculate lambda
            lambda <= ((3 * x1 * x1 + a) / (2 * y1)); // λ = (3*x1^2 + a) / (2*y1)
            // Calculate x3 and y3
            x3 <= (lambda * lambda) - (2 * x1); // x3 = λ^2 - 2*x1
            y3 <= (lambda * (x1 - x3)) - y1; // y3 = λ*(x1 - x3) - y1
        end
    end
endmodule