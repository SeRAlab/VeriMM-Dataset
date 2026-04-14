module DAC_16bit (
    input [15:0] digital_input,
    output reg [15:0] analog_output
);
    always @(*) begin
        analog_output = digital_input;  // Direct mapping for a simple DAC
    end
endmodule