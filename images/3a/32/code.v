module voltage_regulator (
    input [2:0] voltage_in,
    output reg [1:0] voltage_out
);

always @(*) begin
    case (voltage_in)
        3'b000: voltage_out = 2'b00; // 0V
        3'b001: voltage_out = 2'b01; // 1V
        3'b010: voltage_out = 2'b10; // 2V
        3'b011: voltage_out = 2'b10; // 2V
        3'b100: voltage_out = 2'b11; // 3V
        3'b101: voltage_out = 2'b11; // 3V
        3'b110: voltage_out = 2'b11; // 3V
        3'b111: voltage_out = 2'b11; // 3V
        default: voltage_out = 2'b00; // default case
    endcase
end

endmodule