module adc_decoder (
    input [23:0] adc_input,
    output reg [31:0] decimal_output
);
    always @(*) begin
        if (adc_input > 24'hFFFFFF) begin
            decimal_output = 32'hFFFFFFFF; // Overflow
        end else begin
            decimal_output = adc_input; // Direct mapping to decimal
        end
    end
endmodule