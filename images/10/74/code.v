module floating_point_adder (
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] sum
);
    wire [8:0] exponent_a, exponent_b;
    wire [23:0] mantissa_a, mantissa_b;
    wire [24:0] mantissa_sum;
    reg [8:0] exponent_sum;
    reg [23:0] mantissa_normalized;
    
    // Extracting components
    assign exponent_a = a[30:23];
    assign exponent_b = b[30:23];
    assign mantissa_a = {1'b1, a[22:0]};
    assign mantissa_b = {1'b1, b[22:0]};
    
    // Aligning mantissas
    wire [8:0] exponent_diff;
    assign exponent_diff = exponent_a - exponent_b;
    wire [24:0] aligned_mantissa_b = (exponent_diff > 0) ? (mantissa_b >> exponent_diff) : mantissa_b;
    wire [24:0] aligned_mantissa_a = (exponent_diff < 0) ? (mantissa_a >> -exponent_diff) : mantissa_a;
    
    // Adding mantissas
    assign mantissa_sum = aligned_mantissa_a + aligned_mantissa_b;
    
    // Normalization (simple implementation)
    always @(*) begin
        if (mantissa_sum[24]) begin
            mantissa_normalized = mantissa_sum[23:0];
            exponent_sum = (exponent_a > exponent_b ? exponent_a : exponent_b) + 1;
        end else begin
            mantissa_normalized = mantissa_sum[23:1];
            exponent_sum = (exponent_a > exponent_b ? exponent_a : exponent_b);
        end
        sum = {1'b0, exponent_sum[7:0], mantissa_normalized[22:0]};
    end
endmodule