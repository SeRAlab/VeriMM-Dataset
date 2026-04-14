module tcp_segmentation(
    input [15:0] tcp_segment,
    input [7:0] segmentation_type,
    output reg [15:0] output_segment
);

always @(*) begin
    case (segmentation_type)
        0: output_segment = tcp_segment; // No segmentation
        1: output_segment = tcp_segment[15:8]; // Segment 1
        2: output_segment = tcp_segment[7:0];  // Segment 2
        3: output_segment = 16'h0000; // Segment 3 (no data)
        default: output_segment = 16'hxxxx; // Undefined segment
    endcase
end

endmodule