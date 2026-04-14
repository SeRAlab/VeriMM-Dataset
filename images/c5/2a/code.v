module unsigned_multiplier (
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] product
);

reg [3:0] partial_products [0:3];

always @(*) begin
    partial_products[0] = A * B[0];
    partial_products[1] = A * B[1];
    partial_products[2] = A * B[2];
    partial_products[3] = A * B[3];
    product = {partial_products[0], partial_products[1][3:0], partial_products[2][3:0], partial_products[3][3:0]};
end

endmodule