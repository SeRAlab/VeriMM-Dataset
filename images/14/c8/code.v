module adc_decoder (
    input [23:0] adc_input,
    output [7:0] binary_output
);
    assign binary_output = (adc_input >> 8) & 8'hFF; // Shift right by 8 and mask to get 8 bits
endmodule