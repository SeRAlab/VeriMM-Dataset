module ADC_8bit (
    input [2:0] analog_input,
    output reg [7:0] digital_output
);
    always @(*) begin
        case (analog_input)
            3'b000: digital_output = 8'b00000000; // 0
            3'b001: digital_output = 8'b00111111; // 63
            3'b010: digital_output = 8'b01111111; // 127
            3'b011: digital_output = 8'b01111111; // 127
            3'b100: digital_output = 8'b11111111; // 255
            3'b101: digital_output = 8'b11111111; // 255
            3'b110: digital_output = 8'b11111111; // 255
            3'b111: digital_output = 8'b11111111; // 255
            default: digital_output = 8'b00000000; // Default case
        endcase
    end
endmodule