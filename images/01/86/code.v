module dac_16bit (
    input [15:0] digital_input,
    output reg [15:0] analog_output
);
    always @(*) begin
        analog_output = (digital_input * 5) / 65535; // Scale 16-bit input to 5V
    end
endmodule