module voltage_regulator(
    input [2:0] voltage_input,
    output reg [4:0] voltage_output
);
    
    always @(*) begin
        case(voltage_input)
            3'b000: voltage_output = 5'b00000; // 0V
            3'b001: voltage_output = 5'b00001; // 1V
            3'b010: voltage_output = 5'b00010; // 2V
            3'b011: voltage_output = 5'b00011; // 3V
            3'b100: voltage_output = 5'b00100; // 4V
            default: voltage_output = 5'b00000; // Default to 0V
        endcase
    end
endmodule