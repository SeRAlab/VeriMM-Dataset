module adc_comparator (
    input [15:0] adc_output,
    input [15:0] reference_value,
    output reg comparator_out
);

always @(*) begin
    if (adc_output > reference_value) 
        comparator_out = 1'b1;
    else 
        comparator_out = 1'b0;
end

endmodule