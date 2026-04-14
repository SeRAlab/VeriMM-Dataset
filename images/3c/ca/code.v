module float_add (
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] sum
);
    wire [7:0] exp_a = a[30:23];
    wire [7:0] exp_b = b[30:23];
    wire [22:0] mant_a = a[22:0];
    wire [22:0] mant_b = b[22:0];
    wire sign_a = a[31];
    wire sign_b = b[31];
    
    wire [7:0] exp_diff = exp_a > exp_b ? exp_a - exp_b : exp_b - exp_a;
    wire [22:0] mant_a_shifted = (exp_a > exp_b) ? mant_a : mant_a >> exp_diff;
    wire [22:0] mant_b_shifted = (exp_b > exp_a) ? mant_b : mant_b >> exp_diff;
    
    wire [23:0] mant_sum = (sign_a == sign_b) ? {1'b1, mant_a_shifted} + {1'b1, mant_b_shifted} : 
                             {1'b1, mant_a_shifted} - {1'b1, mant_b_shifted};
    
    wire [7:0] exp_sum = (sign_a == sign_b) ? (exp_a > exp_b ? exp_a : exp_b) : 
                          (mant_sum[23] ? exp_a : exp_b);
    
    always @(*) begin
        sum = {sign_a, exp_sum, mant_sum[22:0]};
    end
endmodule