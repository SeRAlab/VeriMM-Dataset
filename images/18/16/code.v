module switching_regulator (
    input wire [2:0] control_signal, // 3-bit control signal for output voltage adjustment
    input wire [7:0] input_voltage,   // 8-bit input voltage
    output reg [7:0] output_voltage    // 8-bit output voltage
);
    always @(*) begin
        case(control_signal)
            3'b000: output_voltage = input_voltage;                      // No adjustment
            3'b001: output_voltage = (input_voltage * 90) / 100;       // 90% of input
            3'b010: output_voltage = (input_voltage * 80) / 100;       // 80% of input
            3'b011: output_voltage = (input_voltage * 70) / 100;       // 70% of input
            3'b100: output_voltage = (input_voltage * 60) / 100;       // 60% of input
            3'b101: output_voltage = (input_voltage * 50) / 100;       // 50% of input
            3'b110: output_voltage = (input_voltage * 40) / 100;       // 40% of input
            3'b111: output_voltage = (input_voltage * 30) / 100;       // 30% of input
            default: output_voltage = 8'b0;                              // Default case
        endcase
    end
endmodule