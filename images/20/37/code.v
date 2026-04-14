module adc_simulator(
    input [11:0] analog_input,
    output [15:0] digital_output
);  
    assign digital_output = {4'b0000, analog_input};  
endmodule