module adc_16_to_8 (
    input wire [15:0] adc_input,
    input wire enable,
    output reg [7:0] adc_output
);
    always @(*) begin
        if (enable) begin
            adc_output = adc_input >> 8; // Scale to 8 bits
        end else begin
            adc_output = 8'b0; // Output zero when not enabled
        end
    end
endmodule