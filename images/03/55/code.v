module voltage_regulator (
    input [2:0] voltage_ref,
    output reg [1:0] regulated_voltage
);

always @(*) begin
    case (voltage_ref)
        3'b000: regulated_voltage = 2'b00; // 0V
        3'b001: regulated_voltage = 2'b01; // 1V
        3'b010: regulated_voltage = 2'b01; // 1V
        3'b011: regulated_voltage = 2'b10; // 2V
        3'b100: regulated_voltage = 2'b10; // 2V
        3'b101: regulated_voltage = 2'b11; // 3V
        3'b110: regulated_voltage = 2'b11; // 3V
        3'b111: regulated_voltage = 2'b11; // 3V
        default: regulated_voltage = 2'b00; // Default case
    endcase
end

endmodule