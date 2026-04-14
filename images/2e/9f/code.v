module floating_point_mult(
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] product
);
    wire [7:0] a_exponent = a[30:23];
    wire [7:0] b_exponent = b[30:23];
    wire [23:0] a_mantissa = {1'b1, a[22:0]};
    wire [23:0] b_mantissa = {1'b1, b[22:0]};
    
    wire [47:0] mantissa_product = a_mantissa * b_mantissa;
    
    wire [7:0] exponent_sum = a_exponent + b_exponent - 8'd127;
    
    always @(*) begin
        product[31] = a[31] ^ b[31]; // Sign bit
        product[30:23] = exponent_sum;
        product[22:0] = mantissa_product[47:24]; // Normalization (assuming no overflow)
    end
endmodule