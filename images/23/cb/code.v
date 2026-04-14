module DAC_24bit (
    input [23:0] digital_input,
    output reg [31:0] analog_output
);
    parameter V_ref = 32'h00000000; // V_ref = 3.3V in fixed-point representation (assumed scale)
    always @(*) begin
        analog_output = (digital_input * V_ref) >> 24; // Scale to V_ref range
        if (analog_output < 32'd0) 
            analog_output = 32'd0; // Clamp to 0V
        else if (analog_output > V_ref) 
            analog_output = V_ref; // Clamp to V_ref
    end
endmodule