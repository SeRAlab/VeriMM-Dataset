module otsu_threshold(input [7:0] pixel_value,  
                      output reg binary_output);  
    reg [7:0] threshold;  
    reg [7:0] pixel_set [0:4]; // Simplified preset pixel values for thresholding  
    integer i;  
    initial begin  
        // Assuming a fixed set of pixel values  
        pixel_set[0] = 8'd50;  
        pixel_set[1] = 8'd100;  
        pixel_set[2] = 8'd150;  
        pixel_set[3] = 8'd200;  
        pixel_set[4] = 8'd250;  
        
        // Calculate threshold as the mean of the pixel_set  
        threshold = (pixel_set[0] + pixel_set[1] + pixel_set[2] + pixel_set[3] + pixel_set[4]) / 5;  
    end  

    always @(*) begin  
        if (pixel_value >= threshold)  
            binary_output = 1'b1;  
        else  
            binary_output = 1'b0;  
    end  
endmodule