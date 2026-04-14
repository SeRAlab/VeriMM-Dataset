module tcp_segmentation(  
    input [15:0] payload_length,  // payload length in bytes  
    output reg [15:0] num_segments, // output number of segments  
    output reg [15:0] last_segment_size // output size of last segment  
);  
    parameter MSS = 1460; // maximum segment size  
   
    always @(*) begin  
        if (payload_length == 0) begin  
            num_segments = 0;  
            last_segment_size = 0;  
        end else if (payload_length <= MSS) begin  
            num_segments = 1;  
            last_segment_size = payload_length;  
        end else begin  
            num_segments = (payload_length + MSS - 1) / MSS; // ceiling division  
            last_segment_size = payload_length % MSS;  
            if (last_segment_size == 0)  
                last_segment_size = MSS;  
        end  
    end  
endmodule