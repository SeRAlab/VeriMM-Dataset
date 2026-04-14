module adc_converter (
    input [9:0] binary_input,
    output [7:0] binary_output
);
    assign binary_output = binary_input / 4;
endmodule