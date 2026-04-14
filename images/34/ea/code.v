module DAC8Bit (
    input [7:0] data_in,
    output reg [9:0] voltage_out
);
    parameter V_REF = 5; // Reference voltage
    
    always @(*) begin
        voltage_out = (data_in * 1023) / 255; // Convert 8-bit input to 10-bit output
    end
endmodule