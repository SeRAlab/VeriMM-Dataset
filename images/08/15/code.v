module carry_save_adder(input [2:0] A,  
                         input [2:0] B,  
                         input [2:0] C,  
                         output [3:0] sum);  
    wire [3:0] carry;  
    wire [3:0] temp_sum;  
    assign carry[0] = (A[0] & B[0]) | (B[0] & C[0]) | (C[0] & A[0]);  
    assign carry[1] = (A[1] & B[1]) | (B[1] & C[1]) | (C[1] & A[1]) | carry[0];  
    assign temp_sum[0] = A[0] ^ B[0] ^ C[0];  
    assign temp_sum[1] = A[1] ^ B[1] ^ C[1];  
    assign temp_sum[2] = A[2] ^ B[2] ^ C[2];  
    assign sum = {carry[1], temp_sum[2:0]} + carry[0];  
endmodule