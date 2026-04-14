module adc_24_to_12 (
    input [23:0] adc_input,
    output reg [11:0] digital_output
);
    always @(*) begin
        if (adc_input <= 24'hFFFFFF) begin
            digital_output = adc_input[23:12]; // Take the upper 12 bits
        end else begin
            digital_output = 12'hFFF; // Max value for 12 bits
        end
    end
endmodule