module floating_point_adder(
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] result
);
    
    wire sign_a = a[31];
    wire sign_b = b[31];
    wire [7:0] exp_a = a[30:23];
    wire [7:0] exp_b = b[30:23];
    wire [22:0] frac_a = a[22:0];
    wire [22:0] frac_b = b[22:0];

    wire [7:0] exp_diff;
    wire [22:0] frac_a_shifted, frac_b_shifted;
    wire [31:0] frac_a_ext, frac_b_ext;

    assign exp_diff = (exp_a > exp_b) ? (exp_a - exp_b) : (exp_b - exp_a);
    assign frac_a_shifted = (exp_a > exp_b) ? frac_a : frac_a >> exp_diff;
    assign frac_b_shifted = (exp_a > exp_b) ? frac_b >> exp_diff : frac_b;

    wire [23:0] sum_frac = (sign_a == sign_b) ? {1'b0, frac_a_shifted} + {1'b0, frac_b_shifted} : {1'b0, frac_a_shifted} - {1'b0, frac_b_shifted};

    always @(*) begin
        if (a == 32'h00000000) begin
            result = b; // a is zero
        end else if (b == 32'h00000000) begin
            result = a; // b is zero
        end else if (exp_a == 8'hFF || exp_b == 8'hFF) begin
            result = (exp_a == 8'hFF && frac_a != 0) ? a : b; // NaN case
        end else if (sum_frac[23]) begin
            result = {sign_a, exp_a + 1'b1, sum_frac[22:1]}; // Normal case
        end else begin
            result = {sign_a, exp_a, sum_frac[21:0]}; // Denormal case
        end
    end
endmodule