module tcp_segmentation(  
    input [15:0] tcp_segment_size,  
    input [15:0] mss,  
    output [15:0] actual_segment_size  
);  
    assign actual_segment_size = (tcp_segment_size > mss) ? mss : tcp_segment_size;  
endmodule