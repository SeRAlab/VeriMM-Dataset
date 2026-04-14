module adc_comparator (
    input [15:0] adc_input1,
    input [15:0] adc_input2,
    output reg greater_than
);
    always @(*) begin
        greater_than = (adc_input1 > adc_input2);
    end
endmodule