module bilinear_interpolation (
    input [7:0] Q11,
    input [7:0] Q12,
    input [7:0] Q21,
    input [7:0] Q22,
    input [7:0] u,
    input [7:0] v,
    output reg [15:0] Q
);
    wire [15:0] term1, term2, term3, term4;

    assign term1 = (256 - u) * (256 - v) * Q11;
    assign term2 = (256 - u) * v * Q12;
    assign term3 = u * (256 - v) * Q21;
    assign term4 = u * v * Q22;

    always @(*) begin
        Q = (term1 + term2 + term3 + term4) >> 16; // Right shift to adjust for fixed point
    end
endmodule