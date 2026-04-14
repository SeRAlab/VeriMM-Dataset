module adc_8bit (
    input wire [3:0] analog_input,
    output wire [7:0] digital_output
);
    assign digital_output = (analog_input > 4'b1111) ? 8'hFF : {4'b0000, analog_input} * 16;
endmodule