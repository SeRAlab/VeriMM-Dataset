module morphological_dilation (  
    input [8:0] image,  // 3x3 image represented as a 9-bit input  
    output reg dilated_pixel  
);  
    always @(*) begin  
        // Perform dilation by checking if any bit in the input is '1'  
        if (image)  
            dilated_pixel = 1;  
        else  
            dilated_pixel = 0;  
    end  
endmodule