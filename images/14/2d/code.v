module adc_converter (
    input [7:0] analog_input,
    output reg [15:0] digital_output
);
    always @(*) begin
        digital_output = analog_input * 256; // Scale 8-bit to 16-bit
    end
endmodule