module adc_simulator (
    input [15:0] analog_value,
    output [15:0] digital_value
);
    assign digital_value = analog_value;
endmodule