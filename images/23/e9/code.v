module adc_decoder (
    input [23:0] adc_input,
    output reg [3:0] range_output
);
    always @(*) begin
        if (adc_input < 32)
            range_output = adc_input[4:1]; // Using bits 4 to 1 for the range output
        else
            range_output = 4'b1111; // Clamp to 15 if adc_input >= 32
    end
endmodule