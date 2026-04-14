module Conv2D (
    input [7:0] I00, I01, I10, I11,   // 3x3 input matrix, using 4 elements (for simplicity)
    input [7:0] K00, K01,             // 2x2 kernel
    output reg [15:0] output_value      // 16-bit output value
);
    always @(*) begin
        output_value = (I00 * K00) + (I01 * K01) + (I10 * K00) + (I11 * K01);
    end
endmodule