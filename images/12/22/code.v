module lu_decomposition (
    input [7:0] a, // a
    input [7:0] b, // b
    input [7:0] c, // c
    input [7:0] d, // d
    output reg [7:0] l11, // l11
    output reg [7:0] l21, // l21
    output reg [7:0] u11, // u11
    output reg [7:0] u12, // u12
    output reg [7:0] u22  // u22
);

always @(*) begin
    // LU Decomposition calculations for 2x2 matrix
    l11 = a;                  // l11 = a
    l21 = c / l11;           // l21 = c/a
    u11 = l11;               // u11 = l11
    u12 = b;                 // u12 = b
    u22 = d - (l21 * u12);  // u22 = d - (l21 * u12)
end
endmodule