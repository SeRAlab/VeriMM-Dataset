module dac_24bit (
    input [23:0] digital_input,
    output reg [15:0] analog_output // 16-bit analog output representing voltage in millivolts
);
    parameter MAX_VALUE = 24'hFFFFFF; // Maximum 24-bit value
    parameter MAX_VOLTAGE = 1000; // 1V in millivolts

    always @(*) begin
        analog_output = (digital_input * MAX_VOLTAGE) / MAX_VALUE; // Scale input to output voltage
    end
endmodule