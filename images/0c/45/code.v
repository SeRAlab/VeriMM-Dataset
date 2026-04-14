module otsu_threshold(input [7:0] pixel_value, output reg binary_output);  
    parameter THRESHOLD = 128; // Example threshold value  
    always @(*) begin  
        if (pixel_value > THRESHOLD)  
            binary_output = 1;  
        else  
            binary_output = 0;  
    end  
endmodule