module morphological_dilation(  
    input [8:0] in_matrix,  // 3x3 input matrix represented as a 9-bit vector  
    output reg out_bit      // Output bit after dilation  
);  
    integer i;  
    always @(*) begin  
        out_bit = 0;  // Initialize output  
        for (i = 0; i < 9; i = i + 1) begin  
            if (in_matrix[i] == 1) begin  
                out_bit = 1;  // Set output to 1 if any bit is 1  
            end  
        end  
    end  
endmodule