module tcp_segmenter (
    input clk,
    input reset,
    input [7:0] data_in,
    input data_valid,
    output reg [31:0] tcp_segment,
    output reg segment_valid
);
    reg [3:0] packet_count;
    reg [31:0] segment_buffer;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            packet_count <= 0;
            segment_buffer <= 0;
            tcp_segment <= 0;
            segment_valid <= 0;
        end else if (data_valid) begin
            segment_buffer <= {segment_buffer[23:0], data_in}; // Shift in the new packet
            packet_count <= packet_count + 1;
            if (packet_count == 3) begin
                tcp_segment <= segment_buffer; // output the completed segment
                segment_valid <= 1;
                packet_count <= 0; // reset count for next segment
                segment_buffer <= 0; // clear buffer
            end else begin
                segment_valid <= 0; // set segment valid low until we fill 4 packets
            end
        end
    end 

    always @(negedge clk) begin
        if (segment_valid && packet_count < 3) begin
            tcp_segment <= {segment_buffer[23:0], 8'b0}; // pad with zeros if needed
        end
    end
endmodule