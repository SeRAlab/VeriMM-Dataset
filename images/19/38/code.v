module otsu_threshold (  
    input wire [7:0] pixel_value,  
    input wire [7:0] threshold,  
    input wire enable,  
    output reg binary_output  
);  
    always @(*) begin  
        if (enable) begin  
            if (pixel_value >= threshold)  
                binary_output = 1;  
            else  
                binary_output = 0;  
        end else begin  
            binary_output = 0;  
        end  
    end  
endmodule