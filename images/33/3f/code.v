module adc_comparator (
    input [23:0] ADC1,
    input [23:0] ADC2,
    output reg greater
);
    always @(*) begin
        if (ADC1 > ADC2)
            greater = 1'b1;
        else
            greater = 1'b0;
    end
endmodule