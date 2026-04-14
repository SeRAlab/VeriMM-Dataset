module dac_16bit (
    input [15:0] binary_input,
    output reg [15:0] analog_output
);

always @(*) begin
    // Direct mapping from binary input to analog output
    analog_output = binary_input;
end

endmodule