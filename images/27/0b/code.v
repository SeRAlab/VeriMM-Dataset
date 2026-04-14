module adc_comparator(
    input [15:0] adc_input,
    input [15:0] reference_level,
    output reg output_signal
);
    always @(*) begin
        if (adc_input > reference_level) 
            output_signal = 1'b1;
        else 
            output_signal = 1'b0;
    end
endmodule