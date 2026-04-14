module tcp_segmentation (
    input [15:0] segment_size,
    input [1:0] segmentation_type,
    output reg [15:0] adjusted_size
);

always @(*) begin
    case (segmentation_type)
        2'b00: adjusted_size = segment_size; // No Segmentation
        2'b01: adjusted_size = segment_size > 1460 ? 1460 : segment_size; // Maximum Segment Size
        2'b10: adjusted_size = segment_size > 1200 ? 1200 : segment_size; // Selective Acknowledgment
        2'b11: adjusted_size = segment_size > 1500 ? 1500 : segment_size; // Path MTU Discovery
        default: adjusted_size = segment_size; // Default case
    endcase
end

endmodule