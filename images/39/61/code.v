module adc_converter (
    input [15:0] adc_input,
    output reg [15:0] adc_output
);
    always @(*) begin
        adc_output = (adc_input * 5) / 65535;
    end
endmodule