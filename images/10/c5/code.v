module LU_Decomposition (
    input [15:0] a11, a12, a21, a22,
    output reg [15:0] l11, l12, l21, l22,
    output reg [15:0] u11, u12, u21, u22,
    input clk,
    input rst
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            l11 <= 0; l12 <= 0; l21 <= 0; l22 <= 0;
            u11 <= 0; u12 <= 0; u21 <= 0; u22 <= 0;
        end else begin
            // LU decomposition for 2x2 matrix
            l11 <= a11;
            l12 <= a12;
            l21 <= a21 / l11; // Assuming l11 is not zero
            l22 <= a22 - (l21 * u12);
            
            u11 <= l11;
            u12 <= a12;
            u21 <= 0; // Lower part of U is zero
            u22 <= a22 - (l21 * u12);
        end
    end
endmodule