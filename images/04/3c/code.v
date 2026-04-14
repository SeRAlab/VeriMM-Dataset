module tcp_segmenter(
    input clk,
    input reset,
    input [7:0] data_in,
    input data_valid,
    output reg [7:0] packet_out,
    output reg last_packet
);
    parameter PACKET_SIZE = 4; // Number of bytes per packet
    reg [2:0] byte_count; // Count of bytes in the current packet
    reg [31:0] packet_buffer; // Buffer to hold the current packet

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            byte_count <= 0;
            last_packet <= 0;
            packet_buffer <= 0;
        end else if (data_valid) begin
            packet_buffer <= {packet_buffer[23:0], data_in}; // Shift in new data
            byte_count <= byte_count + 1;

            if (byte_count == PACKET_SIZE - 1) begin
                packet_out <= packet_buffer[31:24]; // Output the packet
                last_packet <= 1; // Indicate last packet
                byte_count <= 0; // Reset byte count
                packet_buffer <= 0; // Clear buffer
            end else begin
                last_packet <= 0; // Not the last packet yet
            end
        end
    end
endmodule