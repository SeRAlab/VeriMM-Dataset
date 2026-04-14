module dac_24bit (
    input [23:0] digital_input,
    input [7:0] v_ref, // Reference voltage in integer representation
    output reg [15:0] analog_output // Output voltage in scaled integer format
);

    always @(*) begin
        analog_output = (digital_input * v_ref) >> 8; // Scale the output
    end
endmodule