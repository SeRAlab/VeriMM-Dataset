module dynamic_range_compressor (
    input [7:0] in_signal,
    input [1:0] control,
    output reg [7:0] out_signal
);
    always @(*) begin
        case(control)
            2'b00: out_signal = in_signal;                            // 1:1 ratio
            2'b01: out_signal = in_signal >> 1;                      // 2:1 ratio
            2'b10: out_signal = in_signal >> 2;                      // 4:1 ratio
            2'b11: out_signal = in_signal >> 3;                      // 8:1 ratio
            default: out_signal = 8'b0;
        endcase
        // Ensure the output is capped at 8 bits
        if (out_signal > 8'hFF) out_signal = 8'hFF;
    end
endmodule