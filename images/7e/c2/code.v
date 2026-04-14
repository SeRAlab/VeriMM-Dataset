module mul_32bit(
    input wire [15:0] A,
    input wire [15:0] B,
    output wire [31:0] product
    );

reg [31:0] product_reg;

always @(*) begin
    product_reg = A * B;
end

assign product = product_reg;

endmodule