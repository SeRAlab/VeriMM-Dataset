module tcp_segmentation_controller(  
    input wire clk,  
    input wire reset,  
    input wire [15:0] payload_size, // Current payload size  
    input wire [15:0] mss,          // Maximum segment size  
    output reg segment_required      // Output signal indicating if segmentation is required  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            segment_required <= 0;  
        end else begin  
            if (payload_size > mss)  
                segment_required <= 1;  
            else  
                segment_required <= 0;  
        end  
    end  
endmodule