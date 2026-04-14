module hough_transform_accumulator(  
    input [15:0] binary_image,  
    output reg [3:0] accumulator  
);  
    integer i;  
    always @(*) begin  
        accumulator = 4'b0000;  
        for (i = 0; i < 16; i = i + 1) begin  
            if (binary_image[i]) begin  
                accumulator = accumulator + 1;  
            end  
        end  
    end  
endmodule