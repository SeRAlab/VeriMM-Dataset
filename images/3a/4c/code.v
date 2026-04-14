module adc_comparator (
    input [15:0] adc1,
    input [15:0] adc2,
    output reg [1:0] result
);
    always @(*) begin
        if (adc1 < adc2)
            result = 2'b00; // ADC1 < ADC2
        else if (adc1 == adc2)
            result = 2'b01; // ADC1 = ADC2
        else
            result = 2'b10; // ADC1 > ADC2
    end
endmodule