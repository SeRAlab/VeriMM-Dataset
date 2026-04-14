module tcp_segmenter (
    input clk,
    input rst,
    input [31:0] data_in,      // Input data packet
    input [15:0] mss,          // Maximum Segment Size
    input data_valid,          // Input data valid signal
    output reg [31:0] data_out, // Output segmented packet
    output reg segment_done     // Segmentation done signal
);

    reg [15:0] bytes_remaining; // Remaining bytes to segment
    reg [31:0] packet_buffer;    // Buffer for current packet
    reg [3:0] segment_count;     // Counter for segments

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 0;
            segment_done <= 0;
            bytes_remaining <= 0;
            packet_buffer <= 0;
            segment_count <= 0;
        end else if (data_valid) begin
            if (bytes_remaining == 0) begin
                // Start a new packet
                packet_buffer <= data_in;
                bytes_remaining <= {1'b0, mss}; // Load MSS
                segment_count <= 0;
            end
            
            // Segment the current packet
            if (bytes_remaining > 0) begin
                data_out <= packet_buffer[31:0];
                bytes_remaining <= bytes_remaining - 1;
                segment_count <= segment_count + 1;
                
                // Check if we have completed the segmentation
                if (bytes_remaining == 1) begin
                    segment_done <= 1; // Set done signal
                end else begin
                    segment_done <= 0; // Not done yet
                end
            end
        end
    end
endmodule