module temperature_sensor (
    input [3:0] temp_input, // 4-bit temperature input
    output safe_output       // 1-bit output indicating safe temperature
);
    assign safe_output = (temp_input >= 4'b0000 && temp_input <= 4'b11110); // 0 to 30 in binary
endmodule