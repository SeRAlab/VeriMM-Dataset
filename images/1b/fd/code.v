module tcp_segmentation(
    input [7:0] segment_size,
    input [7:0] MSS,
    output reg segmentation_required
);
    always @(*) begin
        if (segment_size > MSS) 
            segmentation_required = 1'b1; // Segmentation is required
        else 
            segmentation_required = 1'b0; // No segmentation required
    end
endmodule