module lu_decomposition (
    input [15:0] a11, a12, a21, a22,
    output reg [15:0] l21,
    output reg [15:0] u11, u12, u22
);
    
    always @(*) begin
        u11 = a11;
        u12 = a12;
        l21 = a21 / u11;
        u22 = a22 - (l21 * u12);
    end
endmodule