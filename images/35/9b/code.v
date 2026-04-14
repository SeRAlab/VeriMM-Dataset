module dynamic_range_compressor (
    input [3:0] in_signal,
    output reg [3:0] out_signal
);
    parameter THRESHOLD = 8;
    parameter COMPRESSION_RATIO = 2;

    always @(*) begin
        if (in_signal > THRESHOLD) begin
            out_signal = in_signal / COMPRESSION_RATIO;
        end else begin
            out_signal = in_signal;
        end
    end
endmodule