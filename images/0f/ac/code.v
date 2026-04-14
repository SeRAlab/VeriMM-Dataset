module floating_point_adder(  
    input [31:0] a,  
    input [31:0] b,  
    output reg [31:0] sum  
);  
    wire [7:0] exp_a, exp_b;  
    wire [22:0] frac_a, frac_b;  
    wire sign_a, sign_b;  
    wire [7:0] exp_sum;  
    wire [23:0] frac_sum;  
    wire [23:0] frac_a_norm, frac_b_norm;  
    wire [7:0] exp_diff;  
    wire [23:0] frac_a_shifted, frac_b_shifted;  
    wire sign_sum;  
    
    assign sign_a = a[31];  
    assign sign_b = b[31];  
    assign exp_a = a[30:23];  
    assign exp_b = b[30:23];  
    assign frac_a = a[22:0];  
    assign frac_b = b[22:0];  
    
    // Normalize fractions
    assign frac_a_norm = {1'b1, frac_a};  
    assign frac_b_norm = {1'b1, frac_b};  
    assign exp_diff = exp_a - exp_b;  
    
    // Shift fractions according to exponent difference
    assign frac_a_shifted = frac_a_norm >> exp_diff;  
    assign frac_b_shifted = frac_b_norm >> (-exp_diff);  
    
    // Perform addition or subtraction
    assign {sign_sum, frac_sum} = (sign_a == sign_b) ?  
                                   {1'b0, frac_a_shifted + frac_b_shifted} :  
                                   {1'b0, frac_a_shifted - frac_b_shifted};  
    
    // Combine result into sum
    always @(*) begin  
        if (sum == 32'h7F800000 || sum == 32'hFF800000)  
            sum = 32'h7F800000; // Handle infinity and NaN  
        else  
            sum = {sign_sum, exp_sum, frac_sum[22:0]};  
    end  
endmodule