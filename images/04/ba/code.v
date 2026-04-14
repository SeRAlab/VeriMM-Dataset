module tcp_segmentation(  
    input [15:0] segment_length,  
    input [15:0] mss,  
    output reg [3:0] num_segments  
);  
    always @(*) begin  
        if (segment_length == 0)  
            num_segments = 0;  
        else if (segment_length <= mss)  
            num_segments = 1;  
        else  
            num_segments = (segment_length + mss - 1) / mss;  
    end  
endmodule