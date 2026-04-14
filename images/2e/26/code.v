module tcp_segmenter (
    input clk,
    input rst,
    input [127:0] data_in,
    input data_valid,
    output reg [127:0] segment_out,
    output reg segment_valid
);
    parameter SEGMENT_SIZE = 128; // Fixed segment size
    reg [6:0] byte_count; // To keep track of bytes in the current segment

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            byte_count <= 0;
            segment_out <= 0;
            segment_valid <= 0;
        end else if (data_valid) begin
            segment_out <= data_in;
            byte_count <= byte_count + SEGMENT_SIZE;
            segment_valid <= 1;
        end else begin
            segment_valid <= 0;
        end
    end
endmodule