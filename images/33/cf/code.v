module tcp_segmenter (
    input [15:0] payload_size, // Size of the TCP payload in bytes
    input [15:0] mss,          // Maximum Segment Size in bytes
    output reg [15:0] segment_size, // Size of the segmented packet in bytes
    output reg valid           // Indicates if the segment is valid
);
    always @(*) begin
        if (payload_size == 0) begin
            segment_size = 0;
            valid = 0;
        end else if (payload_size <= mss) begin
            segment_size = payload_size;
            valid = 1;
        end else begin
            segment_size = mss;
            valid = 1;
        end
    end
endmodule