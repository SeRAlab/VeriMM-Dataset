module adc_comparator (
    input [15:0] adc_value1,
    input [15:0] adc_value2,
    output reg greater
);
    always @(*) begin
        if (adc_value1 > adc_value2)
            greater = 1'b1;
        else
            greater = 1'b0;
    end
endmodule