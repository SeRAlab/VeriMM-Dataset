module qam_modulator(
    input wire I,
    input wire Q,
    output reg [3:0] output_signal
);
    always @(*) begin
        case ({I, Q})
            2'b00: output_signal = 4'b0000; // 00 -> 0000
            2'b01: output_signal = 4'b0001; // 01 -> 0001
            2'b10: output_signal = 4'b0010; // 10 -> 0010
            2'b11: output_signal = 4'b0011; // 11 -> 0011
            default: output_signal = 4'b0000; // Default case
        endcase
    end
endmodule