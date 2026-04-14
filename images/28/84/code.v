module adc_comparator(
    input [15:0] adc_value,
    input [15:0] reference_value,
    output reg greater,
    output reg less,
    output reg equal
);
    always @(*) begin
        if (adc_value > reference_value) begin
            greater = 1'b1;
            less = 1'b0;
            equal = 1'b0;
        end else if (adc_value < reference_value) begin
            greater = 1'b0;
            less = 1'b1;
            equal = 1'b0;
        end else begin
            greater = 1'b0;
            less = 1'b0;
            equal = 1'b1;
        end
    end
endmodule