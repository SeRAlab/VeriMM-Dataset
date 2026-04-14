module dac8bit (
    input [7:0] input_value,
    output reg [11:0] analog_output // 12-bit output to represent voltage level
);
    parameter V_REF = 5; // Reference voltage
    parameter MAX_VALUE = 255; // Maximum 8-bit value
    always @(*) begin
        analog_output = (input_value * V_REF * 4095) / (MAX_VALUE * 5); // Scaled to 12-bits
    end
endmodule