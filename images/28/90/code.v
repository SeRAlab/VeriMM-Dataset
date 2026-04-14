module DAC (
    input [7:0] binary_in,
    output reg [7:0] analog_out
);
    always @(*) begin
        analog_out = binary_in; // Directly assign the 8-bit input to the output
    end
endmodule