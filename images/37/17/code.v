module tcp_segmenter #(
    parameter DATA_WIDTH = 32,
    parameter SEGMENT_SIZE = 8
) (
    input [DATA_WIDTH-1:0] data_in,
    input valid_in,
    output reg [SEGMENT_SIZE-1:0] segment_out,
    output reg valid_out
);
    integer i;

    always @(*) begin
        valid_out = 0;
        if (valid_in) begin
            for (i = 0; i < SEGMENT_SIZE; i = i + 1) begin
                segment_out[i] = data_in[i];
            end
            valid_out = 1;
        end else begin
            segment_out = 0;
        end
    end
endmodule