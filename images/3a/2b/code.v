module eeprom_cell (
    input [4:0] data_in,
    input write_enable,
    output reg [4:0] data_out
);
    always @(*) begin
        if (write_enable) begin
            data_out = data_in;  // Write data to EEPROM
        end
        // else: data_out retains its value (hold)
    end
endmodule