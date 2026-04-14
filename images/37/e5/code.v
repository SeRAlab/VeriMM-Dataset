module adc_8bit (
    input [2:0] voltage_level,
    output reg [7:0] digital_value
);

always @(*) begin
    case (voltage_level)
        3'b000: digital_value = 8'b00000000; // 0
        3'b001: digital_value = 8'b00111111; // 63
        3'b010: digital_value = 8'b01111111; // 127
        3'b011: digital_value = 8'b01111111; // 191
        3'b100: digital_value = 8'b11111111; // 255
        default: digital_value = 8'b00000000; // Default to 0
    endcase
end

endmodule