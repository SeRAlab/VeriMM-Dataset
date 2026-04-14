module adc_16bit (
    input [15:0] analog_input,
    output reg [3:0] digital_output
);

always @(*) begin
    digital_output = analog_input[15:12]; // Taking the top 4 bits for quantization
end

endmodule