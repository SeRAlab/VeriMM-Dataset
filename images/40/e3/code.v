module adc_24bit (
    input [23:0] adc_input,  // 24-bit unsigned input
    output reg [23:0] adc_output // 24-bit signed output (2's complement)
);

always @(*) begin
    if (adc_input == 24'b0) begin
        adc_output = 24'b100000000000000000000000; // -2^23
    end else if (adc_input == 24'hFFFFFF) begin
        adc_output = 24'b011111111111111111111111; // 2^23 - 1
    end else begin
        adc_output = adc_input[23] ? (adc_input - 24'h800000) : adc_input; // 2's complement conversion
    end
end

endmodule