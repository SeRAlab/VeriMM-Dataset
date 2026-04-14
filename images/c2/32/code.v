module MUX4X1 (
    input [3:0] input_signals,
    input [1:0] select_signals,
    output reg output_signal
);

always @ (*)
begin
    case ({select_signals})
        2'b00: output_signal = input_signals[0];
        2'b01: output_signal = input_signals[1];
        2'b10: output_signal = input_signals[2];
        2'b11: output_signal = input_signals[3];
        default: output_signal = 1'bx;
    endcase
end

endmodule