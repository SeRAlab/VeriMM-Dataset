module adc_comparator (
    input [23:0] adc_value,
    output reg result
);
    parameter REFERENCE_VALUE = 24'd12345678;

    always @(*) begin
        if (adc_value > REFERENCE_VALUE) 
            result = 1'b1;
        else 
            result = 1'b0;
    end
endmodule