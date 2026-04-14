module DAC_16bit (
    input [15:0] binary_input,
    output reg [15:0] analog_output
);
    always @(*) begin
        analog_output = binary_input; // Direct mapping for DAC
    end
endmodule