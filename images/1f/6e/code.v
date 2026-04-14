module morphological_dilation(  
    input [8:0] pixel_matrix,  
    output reg dilated_out  
);  
    always @(*) begin  
        if (|pixel_matrix)  
            dilated_out = 1;  
        else  
            dilated_out = 0;  
    end  
endmodule