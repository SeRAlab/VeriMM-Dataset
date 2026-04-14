module adc_8bit (
    input [2:0] voltage_level,
    output reg [7:0] digital_output
);

always @(*) begin
    digital_output = voltage_level * 32; // Scale the 3-bit input to 8-bit output
end
endmodule