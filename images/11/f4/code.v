module dac_16bit (
    input [15:0] digital_input,
    output reg analog_output
);
    
always @(*) begin
    if (digital_input >= 16'h8000) begin
        analog_output = 1'b1; // High output for input >= threshold
    end else begin
        analog_output = 1'b0; // Low output for input < threshold
    end
end

endmodule