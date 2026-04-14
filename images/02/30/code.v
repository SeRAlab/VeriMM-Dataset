module dot_product (
    input [39:0] vector_a, // 5 elements of 8 bits packed (5*8=40 bits)
    input [39:0] vector_b, // 5 elements of 8 bits packed (5*8=40 bits)
    output reg [15:0] dot_product_out // 16-bit output
);
    integer i;
    always @(*) begin
        dot_product_out = 16'b0; // Initialize output to 0
        for (i = 0; i < 5; i = i + 1) begin
            dot_product_out = dot_product_out + (vector_a[i*8 +: 8] * vector_b[i*8 +: 8]);
        end
    end
endmodule