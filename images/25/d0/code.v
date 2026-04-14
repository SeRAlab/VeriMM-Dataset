module adc_converter (
    input [23:0] adc_input,
    output reg [31:0] voltage_output
);
    parameter REFERENCE_VOLTAGE = 32'd3300000; // 3.3V in millivolts
    always @* begin
        voltage_output = (adc_input * REFERENCE_VOLTAGE) >> 24; // Shift right by 24 to scale
    end
endmodule