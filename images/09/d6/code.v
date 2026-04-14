module switching_regulator (
    input [1:0] control,
    output reg output_signal
);
    always @(*) begin
        case (control)
            2'b00: output_signal = 1'b0;  // OFF
            2'b01: output_signal = 1'b1;  // ON_LOW
            2'b10: output_signal = 1'b1;  // ON_MEDIUM
            2'b11: output_signal = 1'b1;  // ON_HIGH
            default: output_signal = 1'b0; // DEFAULT OFF
        endcase
    end
endmodule