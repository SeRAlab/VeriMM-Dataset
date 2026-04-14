module ADC_24_to_32 (
    input [23:0] analog_input,
    output [31:0] digital_output
);
    assign digital_output = {8'b0, analog_input}; // Zero padding to extend to 32-bits
endmodule