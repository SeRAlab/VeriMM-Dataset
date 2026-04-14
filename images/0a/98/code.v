module dilation_3x3(  
    input wire [8:0] in_matrix, // 3x3 input matrix as a 9-bit wire  
    output wire [8:0] out_matrix // 3x3 output matrix as a 9-bit wire  
);  
    assign out_matrix[0] = in_matrix[0] | in_matrix[1] | in_matrix[3];  
    assign out_matrix[1] = in_matrix[0] | in_matrix[1] | in_matrix[2] | in_matrix[3] | in_matrix[4];  
    assign out_matrix[2] = in_matrix[1] | in_matrix[2] | in_matrix[4];  
    assign out_matrix[3] = in_matrix[0] | in_matrix[3] | in_matrix[4] | in_matrix[6];  
    assign out_matrix[4] = in_matrix[1] | in_matrix[3] | in_matrix[4] | in_matrix[5] | in_matrix[7];  
    assign out_matrix[5] = in_matrix[2] | in_matrix[4] | in_matrix[5];  
    assign out_matrix[6] = in_matrix[3] | in_matrix[6] | in_matrix[7];  
    assign out_matrix[7] = in_matrix[4] | in_matrix[6] | in_matrix[7] | in_matrix[8];  
    assign out_matrix[8] = in_matrix[5] | in_matrix[7] | in_matrix[8];  
endmodule