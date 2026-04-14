module switching_regulator (
    input [2:0] voltage_level,
    output reg output_signal
);
    always @(*) begin
        case (voltage_level)
            3'b000: output_signal = 0; // 0V
            3'b001: output_signal = 0; // 1V
            3'b010: output_signal = 0; // 2V
            3'b011: output_signal = 0; // 3V
            3'b100: output_signal = 1; // 4V
            default: output_signal = 0; // Default case
        endcase
    end
endmodule