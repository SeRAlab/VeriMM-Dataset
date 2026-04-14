module lu_decomposition (
    input [31:0] a, // Element a11
    input [31:0] b, // Element a12
    input [31:0] c, // Element a21
    input [31:0] d, // Element a22
    output [31:0] l11, // Element l11
    output [31:0] l21, // Element l21
    output [31:0] u11, // Element u11
    output [31:0] u12, // Element u12
    output [31:0] u21, // Element u21
    output [31:0] u22  // Element u22
);

assign l11 = 1; // l11 is always 1
assign l21 = c / l11; // l21 = a21
assign u11 = a; // u11 = a11
assign u12 = b; // u12 = a12
assign u21 = 0; // u21 = 0 since we are using 2x2 matrix
assign u22 = d - (l21 * u12); // u22 = a22 - l21 * u12

endmodule