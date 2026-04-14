module adc_24_to_32 (
    input [23:0] adc_in,
    output [31:0] adc_out
);
    assign adc_out = {adc_in, 8'b0}; // left-align 24-bit input and fill 8 bits with 0
endmodule