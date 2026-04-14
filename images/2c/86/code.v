module float_add(
    input [31:0] a, // First floating-point number
    input [31:0] b, // Second floating-point number
    output reg [31:0] sum // Resulting floating-point sum
);
    
    wire [7:0] exponent_a = a[30:23];
    wire [7:0] exponent_b = b[30:23];
    wire [23:0] mantissa_a = {1'b1, a[22:0]};
    wire [23:0] mantissa_b = {1'b1, b[22:0]};
    
    wire [7:0] exp_diff = exponent_a > exponent_b ? exponent_a - exponent_b : exponent_b - exponent_a;
    wire [23:0] mantissa_a_shifted = (exponent_a > exponent_b) ? mantissa_a : mantissa_a >> exp_diff;
    wire [23:0] mantissa_b_shifted = (exponent_a > exponent_b) ? mantissa_b >> exp_diff : mantissa_b;

    wire [24:0] sum_mantissa = mantissa_a_shifted + mantissa_b_shifted;
    wire [7:0] result_exponent = (exponent_a > exponent_b) ? exponent_a : exponent_b;
    
    always @(*) begin
        if (sum_mantissa[24]) begin // Handle overflow
            sum = {1'b0, result_exponent + 1'b1, sum_mantissa[23:1]};
        end else begin
            sum = {1'b0, result_exponent, sum_mantissa[22:0]};
        end
    end
endmodule