module top_module(
    input signal_a,
    input signal_b,
    input signal_c,
    output reg[1:0] output_signal
);always @ (signal_a or signal_b or signal_c) begin
    case ({signal_c, signal_b, signal_a})
        3'b000: output_signal = 2'b00;
        3'b001: output_signal = 2'b01;
        3'b010: output_signal = 2'b10;
        3'b011: output_signal = 2'b11;
        3'b100: output_signal = 2'b01;
        3'b101: output_signal = 2'b10;
        3'b110: output_signal = 2'b11;
        3'b111: output_signal = 2'b00;
    endcase
end

endmodule