module DAC_24bit (
    input wire [23:0] digital_input,
    input wire reset,
    output reg [23:0] analog_output
);
    always @(*) begin
        if (reset) begin
            analog_output = 24'b0;  // Reset output to 0
        end else begin
            analog_output = digital_input;  // Pass the digital input to the output
        end
    end
endmodule