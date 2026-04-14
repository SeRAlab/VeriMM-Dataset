module LU_Decomposition(
    input [7:0] a11, a12, 
    input [7:0] a21, a22,
    output reg [7:0] l11, l12, l21, l22,
    output reg [7:0] u11, u12, u21, u22
);

always @(*) begin
    // Initialize outputs
    l11 = a11;
    l12 = 0;
    l21 = a21 / a11; // calculating L21
    l22 = 0;

    u11 = a11;
    u12 = a12;
    u21 = 0; // L has no U matrix
    u22 = a22 - (l21 * u12); // calculating U22
end
endmodule