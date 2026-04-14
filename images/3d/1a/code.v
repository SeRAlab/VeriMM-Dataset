module canny_edge_detection(  
    input [7:0] pixel_value,  
    input [7:0] threshold,  
    output reg edge_flag  
);  
    always @(*) begin  
        if (pixel_value > threshold)  
            edge_flag = 1;  
        else  
            edge_flag = 0;  
    end  
endmodule