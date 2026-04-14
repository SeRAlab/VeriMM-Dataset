module switching_regulator (
    input [1:0] voltage_select,
    output reg regulator_enable
);

always @(*) begin
    case (voltage_select)
        2'b00: regulator_enable = 1'b0; // 0V
        2'b01: regulator_enable = 1'b1; // 1.2V
        2'b10: regulator_enable = 1'b1; // 2.5V
        2'b11: regulator_enable = 1'b0; // 5V
        default: regulator_enable = 1'b0; // Default case
    endcase
end

endmodule