module morphological_dilation (  
    input [8:0] pixel_in,  // 3x3 input pixels represented as a 9-bit vector  
    output reg [2:0] pixel_out  // 3-bit output pixel value  
);  
    integer i;  
    always @(*) begin  
        pixel_out = 3'b000;  // default to zero  
        for (i = 0; i < 9; i = i + 1) begin  
            if (pixel_in[i]) begin  
                pixel_out = 3'b111;  // if any pixel is 1, set the output to 111  
            end  
        end  
    end  
endmodule