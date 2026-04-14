module adc_decoder (
    input [2:0] channel,
    output reg [7:0] adc_output
);
    always @(*) begin
        adc_output = 8'b00000000; // Initialize output
        adc_output[channel] = 1'b1; // Set the corresponding channel bit to 1
    end
endmodule