module adc_converter (
    input [7:0] voltage_input, // 8-bit input representing voltage level
    output [23:0] adc_output    // 24-bit output representing ADC value
);
    assign adc_output = {16'b0, voltage_input}; // Convert 8-bit to 24-bit
endmodule