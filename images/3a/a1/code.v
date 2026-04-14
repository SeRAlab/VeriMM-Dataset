module LDO (
    input [2:0] control,
    output reg [2:0] output_voltage
);
    always @(*) begin
        case (control)
            3'b000: output_voltage = 3'b000; // 0V
            3'b001: output_voltage = 3'b001; // 1V
            3'b010: output_voltage = 3'b010; // 2V
            3'b011: output_voltage = 3'b011; // 3V
            3'b100: output_voltage = 3'b100; // 4V
            3'b101: output_voltage = 3'b101; // 5V
            3'b110: output_voltage = 3'b110; // 6V
            3'b111: output_voltage = 3'b111; // 7V
            default: output_voltage = 3'b000; // default to 0V
        endcase
    end
endmodule