module binary_dilation(  
    input [8:0] in_image,  
    output [8:0] out_image  
);  
    assign out_image[0] = in_image[0] | in_image[1] | in_image[3] | in_image[4];  
    assign out_image[1] = in_image[0] | in_image[1] | in_image[2] | in_image[3] | in_image[4] | in_image[5];  
    assign out_image[2] = in_image[1] | in_image[2] | in_image[4] | in_image[5];  
    assign out_image[3] = in_image[0] | in_image[3] | in_image[4] | in_image[6] | in_image[7];  
    assign out_image[4] = in_image[0] | in_image[1] | in_image[3] | in_image[4] | in_image[5] | in_image[6] | in_image[7] | in_image[8];  
    assign out_image[5] = in_image[1] | in_image[2] | in_image[4] | in_image[5] | in_image[7] | in_image[8];  
    assign out_image[6] = in_image[3] | in_image[4] | in_image[6] | in_image[7];  
    assign out_image[7] = in_image[3] | in_image[4] | in_image[5] | in_image[6] | in_image[7] | in_image[8];  
    assign out_image[8] = in_image[4] | in_image[5] | in_image[7] | in_image[8];  
endmodule