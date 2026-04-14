module adc_comparator (
    input [15:0] adc_output,
    input [15:0] reference_value,
    output reg greater,
    output reg less,
    output reg equal
);
    always @(*) begin
        if (adc_output > reference_value) begin
            greater = 1;
            less = 0;
            equal = 0;
        end else if (adc_output < reference_value) begin
            greater = 0;
            less = 1;
            equal = 0;
        end else begin
            greater = 0;
            less = 0;
            equal = 1;
        end
    end
endmodule