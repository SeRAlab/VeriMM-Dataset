module tcp_segmenter(
    input wire clk,
    input wire reset,
    input wire [15:0] data_in,
    input wire segment_enable,
    output reg [7:0] segment_out,
    output reg [3:0] segment_num,
    output reg valid
);
    reg [15:0] data_buffer;
    reg [2:0] byte_cnt;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_buffer <= 0;
            byte_cnt <= 0;
            segment_num <= 0;
            valid <= 0;
        end else if (segment_enable) begin
            data_buffer <= data_in;
            byte_cnt <= 0;
            segment_num <= 0;
            valid <= 0;
        end else if (byte_cnt < 2) begin
            segment_out <= data_buffer[byte_cnt*8 +: 8];
            valid <= 1;
            byte_cnt <= byte_cnt + 1;
            segment_num <= segment_num + 1;
        end else begin
            valid <= 0;
        end
    end
endmodule