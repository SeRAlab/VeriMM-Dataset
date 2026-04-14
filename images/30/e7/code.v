module adc_8bit (
    input [7:0] analog_input,
    output reg [2:0] digital_output
);
    always @* begin
        case (analog_input[7:5]) // Using the upper 3 bits to determine the range
            3'b000: digital_output = 3'b000; // 0-31
            3'b001: digital_output = 3'b001; // 32-63
            3'b010: digital_output = 3'b010; // 64-95
            3'b011: digital_output = 3'b011; // 96-127
            3'b100: digital_output = 3'b100; // 128-159
            3'b101: digital_output = 3'b101; // 160-191
            3'b110: digital_output = 3'b110; // 192-223
            3'b111: digital_output = 3'b111; // 224-255
            default: digital_output = 3'b000; // Default case
        endcase
    end
endmodule