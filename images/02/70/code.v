module lu_decomposition (
    input [7:0] a11,
    input [7:0] a12,
    input [7:0] a21,
    input [7:0] a22,
    output reg [7:0] l11,
    output reg [7:0] l21,
    output reg [7:0] l22,
    output reg [7:0] u11,
    output reg [7:0] u12,
    output reg [7:0] u22
);

always @(*) begin
    l11 = 8'd1;
    u11 = a11;
    u12 = a12;
    l21 = a21 / u11; // assuming u11 is not zero
    l22 = a22 - (l21 * u12);
    u22 = 8'd0; // u22 is always zero in 2x2 LU decomposition
end

endmodule