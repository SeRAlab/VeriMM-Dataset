module tcp_segmenter (
    input [255:0] tcp_payload, // TCP payload (max 256 bits)
    input [7:0] length,        // Length of the TCP payload
    input [7:0] mss,           // Maximum segment size
    input clk,
    input reset,
    output reg [255:0] segment_out, // Segmented TCP payload output
    output reg [7:0] segment_length, // Length of the current segment
    output reg [7:0] num_segments // Number of segments output
);

reg [7:0] index; // Current index position in the TCP payload
reg [7:0] current_length; // Length of the current segment

always @(posedge clk or posedge reset) begin
    if (reset) begin
        index <= 8'b0;
        num_segments <= 8'b0;
        segment_length <= 8'b0;
        segment_out <= 256'b0;
    end else if (index < length) begin
        current_length <= (length - index > mss) ? mss : (length - index);
        segment_out <= tcp_payload >> (index * 8); // Adjusting TCP payload to output
        segment_length <= current_length;
        num_segments <= num_segments + 1;
        index <= index + current_length; // Move to the next segment
    end
end

endmodule