module binary_multiplier_2bit(A, B, PRODUCT);
input [1:0] A, B;
output reg [3:0] PRODUCT;

always @(*) begin
    PRODUCT = A * B;
end

endmodule