module DVFS (
    input [3:0] frequency,
    output reg [1:0] voltage_level
);
    always @(*) begin
        case (frequency)
            4'b0000: voltage_level = 2'b00; // Level 0
            4'b0001: voltage_level = 2'b01; // Level 1
            4'b0010: voltage_level = 2'b01; // Level 1
            4'b0011: voltage_level = 2'b10; // Level 2
            4'b0100: voltage_level = 2'b10; // Level 2
            4'b0101: voltage_level = 2'b11; // Level 3
            4'b0110: voltage_level = 2'b11; // Level 3
            4'b0111: voltage_level = 2'b00; // Level 0
            4'b1000: voltage_level = 2'b00; // Level 0
            4'b1001: voltage_level = 2'b01; // Level 1
            4'b1010: voltage_level = 2'b01; // Level 1
            4'b1011: voltage_level = 2'b10; // Level 2
            4'b1100: voltage_level = 2'b10; // Level 2
            4'b1101: voltage_level = 2'b11; // Level 3
            4'b1110: voltage_level = 2'b11; // Level 3
            4'b1111: voltage_level = 2'b00; // Level 0
            default: voltage_level = 2'b00; // Default to Level 0
        endcase
    end
endmodule