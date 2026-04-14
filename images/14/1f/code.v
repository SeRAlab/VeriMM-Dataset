module adc_comparator (
    input [23:0] adc_value1,
    input [23:0] adc_value2,
    output reg [1:0] comparison_result
);
    always @* begin
        if (adc_value1 < adc_value2) 
            comparison_result = 2'b00; // adc_value1 is less than adc_value2
        else if (adc_value1 == adc_value2) 
            comparison_result = 2'b01; // adc_value1 is equal to adc_value2
        else 
            comparison_result = 2'b10; // adc_value1 is greater than adc_value2
    end
endmodule