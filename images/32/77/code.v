module floating_point_adder(  
    input [31:0] A,  
    input [31:0] B,  
    output reg [31:0] Sum  
);  
    wire signA, signB;  
    wire [7:0] expA, expB;  
    wire [22:0] mantA, mantB;  
    wire [23:0] mantA_ext, mantB_ext;  
    wire [7:0] exp_diff;  
    wire [23:0] mantA_shifted, mantB_shifted;  
    wire [23:0] mant_sum;  
    wire [7:0] max_exp;  
    wire result_sign;  

    assign signA = A[31];  
    assign signB = B[31];  
    assign expA = A[30:23];  
    assign expB = B[30:23];  
    assign mantA = A[22:0];  
    assign mantB = B[22:0];  

    assign mantA_ext = {1'b1, mantA};  
    assign mantB_ext = {1'b1, mantB};  

    assign exp_diff = expA > expB ? expA - expB : expB - expA;  
    assign max_exp = expA > expB ? expA : expB;  

    assign mantA_shifted = expA > expB ? mantA_ext : mantA_ext >> exp_diff;  
    assign mantB_shifted = expB > expA ? mantB_ext : mantB_ext >> exp_diff;  

    assign mant_sum = (signA == signB) ? (mantA_shifted + mantB_shifted) : (mantA_shifted - mantB_shifted);  

    always @(*) begin  
        if (mant_sum[23]) begin  
            Sum = {signA, max_exp + 1'b1, mant_sum[22:1]};  
        end else begin  
            Sum = {result_sign, max_exp, mant_sum[21:0]};  
        end  
    end  
endmodule