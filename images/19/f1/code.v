module LU_Decomposition (
    input [7:0] a11, a12, a21, a22, // 8-bit inputs for elements of the matrix
    output reg [7:0] l21, 
    output reg [7:0] u11, u12, u22
);
    always @(*) begin
        l21 = a21 / a11; // Calculate l21
        u11 = a11;      // Set u11
        u12 = a12;      // Set u12
        u22 = a22 - l21 * u12; // Calculate u22
    end
endmodule