module DAC_24bit (
    input [23:0] digital_input,
    output reg [7:0] analog_output
);
    always @(*) begin
        analog_output = digital_input[23:16]; // Take the top 8 bits as the analog output
    end
endmodule