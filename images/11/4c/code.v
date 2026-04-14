module dynamic_range_compressor (
    input [4:0] in_signal,
    output reg [4:0] out_signal
);
    parameter THRESHOLD = 5'b01111; // 15
    parameter COMPRESSION_FACTOR = 2;

    always @(*) begin
        if (in_signal <= THRESHOLD) 
            out_signal = in_signal;
        else 
            out_signal = (in_signal / COMPRESSION_FACTOR > 5'b11111) ? 5'b11111 : in_signal / COMPRESSION_FACTOR;
    end
endmodule