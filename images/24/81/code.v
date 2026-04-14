module adc_converter (
    input [23:0] adc_input,
    output reg [11:0] digital_output
);

always @(*) begin
    // Scale the 24-bit input down to 12 bits
    digital_output = adc_input[23:12]; // Taking the top 12 bits for simplicity
end

endmodule