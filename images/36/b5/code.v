module lu_decomposition(
    input [15:0] a, // a[15:0] for input a
    input [15:0] b, // b[15:0] for input b
    input [15:0] c, // c[15:0] for input c
    input [15:0] d, // d[15:0] for input d
    output reg [15:0] l11, // l11 for output L
    output reg [15:0] l12, // l12 for output L
    output reg [15:0] l21, // l21 for output L
    output reg [15:0] l22, // l22 for output L
    output reg [15:0] u11, // u11 for output U
    output reg [15:0] u12, // u12 for output U
    output reg [15:0] u21, // u21 for output U
    output reg [15:0] u22  // u22 for output U
);
    always @(*) begin
        // Compute L and U for the 2x2 matrix
        l11 = 1;          // L11 is always 1
        l12 = 0;          // L12 is always 0
        l21 = c / a;      // L21 is c/a
        l22 = 1;          // L22 is always 1

        u11 = a;          // U11 is a
        u12 = b;          // U12 is b
        u21 = 0;          // U21 is 0
        u22 = d - (l21 * u12); // U22 is d - (c/a)*b
    end
endmodule