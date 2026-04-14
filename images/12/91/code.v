module ADC_Converter (
    input [23:0] adc_input,
    output reg [31:0] voltage_output
);
    parameter REF_VOLTAGE = 32'd5000000; // 5V in millivolts
    always @(*) begin
        voltage_output = (adc_input * REF_VOLTAGE) >> 24; // Scale to 5V
    end
endmodule