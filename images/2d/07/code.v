module DAC (
    input [7:0] binary_input,
    output reg [7:0] analog_output
);
    always @(*) begin
        analog_output = (binary_input * 5) / 255; // Simple scaling for example purposes
    end
endmodule