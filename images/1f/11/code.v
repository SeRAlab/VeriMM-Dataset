module tcp_segmenter (
    input wire clk,
    input wire reset,
    input wire [31:0] data_in,
    input wire valid_data,
    output reg [31:0] packet_out,
    output reg more_data
);
    parameter PACKET_SIZE = 32;
    reg [31:0] data_buffer;
    reg [4:0] byte_count;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            byte_count <= 0;
            packet_out <= 0;
            more_data <= 0;
        end else if (valid_data) begin
            data_buffer <= data_in;
            byte_count <= byte_count + PACKET_SIZE;
            packet_out <= data_buffer; // Assigning data buffer to packet output
            more_data <= (byte_count < 256); // Assuming 256 is the total data size for simplicity
        end
    end
endmodule