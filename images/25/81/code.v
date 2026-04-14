module DAC (
    input [7:0] digital_input,
    output reg [7:0] analog_output
);
    always @(*) begin
        analog_output = digital_input; // Simple 1:1 mapping for this example
    end
endmodule