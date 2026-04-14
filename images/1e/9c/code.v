module morphological_dilation(  
    input [8:0] binary_image,  // 3x3 binary matrix flattened to a 9-bit input  
    output reg dilated_value    // Output of the dilation operation  
);  
    always @(*) begin  
        // Perform dilation: check if there is at least one '1' in the 3x3 region  
        if (binary_image[0] | binary_image[1] | binary_image[2] |  
            binary_image[3] | binary_image[4] | binary_image[5] |  
            binary_image[6] | binary_image[7] | binary_image[8])  
            dilated_value = 1'b1;  
        else  
            dilated_value = 1'b0;  
    end  
endmodule