module tcp_segmenter(
    input clk,
    input rst,
    input [7:0] data_in,
    input data_valid,
    input [15:0] max_packet_size,
    output reg [7:0] packet_out,
    output reg packet_valid
);
    reg [15:0] byte_count;
    reg [7:0] packet_buffer [0:255]; // Buffer for packet storage
    reg [7:0] index;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            byte_count <= 0;
            index <= 0;
            packet_valid <= 0;
        end else if (data_valid) begin
            if (byte_count < max_packet_size) begin
                packet_buffer[byte_count] <= data_in;
                byte_count <= byte_count + 1;
                packet_valid <= 0;
            end 
            if (byte_count == max_packet_size - 1) begin
                packet_out <= packet_buffer[0]; // Output the first byte of the packet
                packet_valid <= 1;
                byte_count <= 0; // Reset byte count after sending the packet
            end
        end
    end
endmodule