module tcp_segmentation (
    input [11:0] segment_size, // Maximum size of 4096 bytes
    output reg [7:0] segmentation_type // "Small", "Medium", "Large" encoded as 8-bit ASCII values
);
    always @(*) begin
        if (segment_size <= 12'd536) 
            segmentation_type <= "Small";
        else if (segment_size <= 12'd1460) 
            segmentation_type <= "Medium";
        else 
            segmentation_type <= "Large";
    end
endmodule