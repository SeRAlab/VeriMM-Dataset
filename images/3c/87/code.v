module DAC (
    input [7:0] dac_in,
    output reg [9:0] dac_out // 10-bit output to represent a scaled voltage level
);

parameter V_ref = 5; // Reference voltage in mV

always @(*) begin
    dac_out = (V_ref * dac_in) / 255; // Scaling the 8-bit input
end

endmodule