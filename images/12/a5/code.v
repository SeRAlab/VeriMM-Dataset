module otsu_threshold #(parameter THRESHOLD = 128) (  
    input [7:0] pixel_value,  
    output reg binary_output  
);  
    always @(*) begin  
        if (pixel_value >= THRESHOLD)  
            binary_output = 1;  
        else  
            binary_output = 0;  
    end  
endmodule