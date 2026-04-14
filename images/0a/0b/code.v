module adc_comparator (
    input [15:0] adc_value,
    input [15:0] threshold,
    output reg greater,
    output reg less,
    output reg equal
);

always @(*) begin
    if (adc_value > threshold) begin
        greater = 1;
        less = 0;
        equal = 0;
    end else if (adc_value < threshold) begin
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