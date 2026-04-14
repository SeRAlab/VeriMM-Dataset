module adc_comparator (
    input [23:0] adc_output,
    input [23:0] reference_value,
    output reg [1:0] comparison_result
);
    always @(*) begin
        if (adc_output < reference_value)
            comparison_result = 2'b00; // Less than
        else if (adc_output == reference_value)
            comparison_result = 2'b01; // Equal to
        else
            comparison_result = 2'b10; // Greater than
    end
endmodule