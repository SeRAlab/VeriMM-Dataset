module adc_processor(
    input [15:0] adc_input,
    output reg [3:0] quant_level
);
    parameter REFERENCE_VALUE = 65536;
    
    always @(*) begin
        quant_level = adc_input * 16 / REFERENCE_VALUE; // Scale the input to a 4-bit level
    end
endmodule