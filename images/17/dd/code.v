module dac_24bit (
    input [23:0] data_in,
    output reg [11:0] voltage_out // Assuming a 12-bit output for voltage representation
);
    parameter MAX_VOLTAGE = 4095; // Assuming 5V corresponds to 4095 in 12-bit
    always @(*) begin
        voltage_out = (data_in * MAX_VOLTAGE) >> 24; // Scale input to 12-bit output
    end
endmodule