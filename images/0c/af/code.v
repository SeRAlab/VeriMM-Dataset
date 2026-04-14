module floating_point_adder(input [31:0] a, input [31:0] b, output [31:0] sum);  
    wire [7:0] exp_a, exp_b, exp_sum;  
    wire [23:0] frac_a, frac_b, frac_sum;  
    wire sign_a, sign_b, sign_sum;  
    wire [24:0] normalized_a, normalized_b;  
  
    assign sign_a = a[31];  
    assign exp_a = a[30:23];  
    assign frac_a = {1'b1, a[22:0]};  // implicit leading 1 for normalized numbers  
  
    assign sign_b = b[31];  
    assign exp_b = b[30:23];  
    assign frac_b = {1'b1, b[22:0]};  // implicit leading 1 for normalized numbers  
  
    // Align exponents
    wire [7:0] exp_diff;  
    wire [24:0] frac_a_shifted, frac_b_shifted;  
    assign exp_diff = exp_a > exp_b ? exp_a - exp_b : exp_b - exp_a;  
    assign frac_a_shifted = exp_a > exp_b ? frac_a : frac_a >> exp_diff;  
    assign frac_b_shifted = exp_a > exp_b ? frac_b >> exp_diff : frac_b;  
  
    // Add or subtract fractions based on the sign bits
    wire [25:0] frac_result;  
    assign frac_result = sign_a == sign_b ? frac_a_shifted + frac_b_shifted : frac_a_shifted - frac_b_shifted;  
  
    // Normalize the result
    assign sign_sum = sign_a;  
    assign exp_sum = exp_a > exp_b ? exp_a : exp_b;  
    assign frac_sum = frac_result[24:1]; // Drop the implicit leading 1  
  
    // Handle overflow and underflow
    assign sum = {sign_sum, exp_sum, frac_sum[22:0]};  
endmodule