module adc_processor (
    input [23:0] adc_input,
    output reg [23:0] adc_output
);
    always @(*) begin
        if (adc_input < 24'b0) begin
            adc_output = 24'b0; // Output all zeros for negative input
        end else if (adc_input > 24'hFFFFFF) begin
            adc_output = 24'hFFFFFF; // Output all ones for values above max
        end else begin
            adc_output = adc_input; // Output the input value as-is
        end
    end
endmodule