module tcp_segmenter (
    input clk,
    input rst,
    input [31:0] data_in,
    input data_valid,
    input [15:0] mss,
    output reg [31:0] tcp_packet_out,
    output reg packet_valid,
    output reg segmentation_done
);
    reg [15:0] data_count;
    reg [31:0] buffer;
    reg [15:0] segment_size;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_count <= 0;
            buffer <= 0;
            segment_size <= 0;
            tcp_packet_out <= 0;
            packet_valid <= 0;
            segmentation_done <= 0;
        end else if (data_valid) begin
            // Buffering data
            buffer <= data_in;
            data_count <= data_count + 1;

            // Check if we can form a complete TCP packet
            if (segment_size < mss) begin
                segment_size <= segment_size + 1;
                tcp_packet_out <= buffer;
                packet_valid <= 1;
            end else begin
                // Reset for next packet
                segment_size <= 1; // Start new segment with current data
                tcp_packet_out <= buffer;
                packet_valid <= 1;
            end
        end else begin
            // Set segmentation done signal when all data is processed
            if (data_count == 0) begin
                segmentation_done <= 1;
            end
        end
    end
endmodule