module LU_Decomposition(
    input clk,
    input rst,
    input [15:0] a11, a12, a21, a22, // Input 2x2 matrix
    output reg [15:0] l11, l12, l21, l22, // Output lower triangular matrix L
    output reg [15:0] u11, u12, u21, u22 // Output upper triangular matrix U
);
    reg [15:0] temp;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            l11 <= 16'd0; l12 <= 16'd0; l21 <= 16'd0; l22 <= 16'd0;
            u11 <= 16'd0; u12 <= 16'd0; u21 <= 16'd0; u22 <= 16'd0;
        end else begin
            // LU Decomposition logic for a 2x2 matrix
            l11 <= a11;    // L11 is A11
            l12 <= 0;      // L12 is 0
            l21 <= a21 / a11; // L21 is A21 / A11
            l22 <= a22 - (l21 * a12); // L22 is A22 - L21 * A12

            u11 <= a11;    // U11 is A11
            u12 <= a12;    // U12 is A12
            u21 <= 0;      // U21 is 0
            u22 <= l22;    // U22 is L22
        end
    end
endmodule