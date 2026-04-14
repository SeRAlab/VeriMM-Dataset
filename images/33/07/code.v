module DAC_Controller (
    input [23:0] dac_input,
    output reg [7:0] dac_output,
    output reg valid
);

always @(*) begin
    // Assuming the DAC takes a linear mapping of the 24-bit input to 8-bit output
    dac_output = dac_input[23:16]; // Take the upper 8 bits for DAC output
    valid = 1'b1; // Output is always valid in this simple model
end

endmodule