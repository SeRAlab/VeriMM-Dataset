module canny_edge_detection(  
    input [7:0] pixel_value,  // 8-bit grayscale pixel value  
    input [7:0] threshold,    // threshold value for edge detection  
    output reg edge_detected   // 1-bit output indicating edge presence  
);  
    always @(*) begin  
        if (pixel_value > threshold)  
            edge_detected = 1;  
        else  
            edge_detected = 0;  
    end  
endmodule