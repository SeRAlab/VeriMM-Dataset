module LU_Decomposition (
    input clk,
    input rst,
    input [31:0] a11, a12,
    input [31:0] a21, a22,
    output reg [31:0] l11, l12, l21, l22,
    output reg [31:0] u11, u12, u21, u22
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            l11 <= 0; l12 <= 0; l21 <= 0; l22 <= 0;
            u11 <= 0; u12 <= 0; u21 <= 0; u22 <= 0;
        end else begin
            // LU Decomposition for 2x2 matrix
            l11 <= 1; // L(1,1) = 1
            l12 <= 0; // L(1,2) = 0
            l21 <= a21 / a11; // L(2,1) = A(2,1) / A(1,1)
            l22 <= 1; // L(2,2) = 1

            u11 <= a11; // U(1,1) = A(1,1)
            u12 <= a12; // U(1,2) = A(1,2)
            u21 <= 0; // U(2,1) = 0
            u22 <= a22 - l21 * u12; // U(2,2) = A(2,2) - L(2,1) * U(1,2)
        end
    end
endmodule