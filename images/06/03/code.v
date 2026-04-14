module dac_24bit (
    input [23:0] digital_input,
    output reg [23:0] analog_output
);
    always @(*) begin
        analog_output = digital_input; // Directly pass the digital input to the output
    end
endmodule