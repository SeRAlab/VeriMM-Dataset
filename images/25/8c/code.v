module tcp_segmentation_type(  
    input [15:0] segment_length,  
    output reg [2:0] segment_type  
);  
    always @(*) begin  
        if (segment_length <= 64)  
            segment_type = 3'b000; // Short  
        else if (segment_length > 64 && segment_length <= 128)  
            segment_type = 3'b001; // Medium  
        else  
            segment_type = 3'b010; // Long  
    end  
endmodule