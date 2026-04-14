module adc_inverter (
    input [23:0] analog_in,
    output [23:0] digital_out
);
    assign digital_out = ~analog_in;
endmodule