module eeprom_cell (
    input [3:0] data_in,
    input write_enable,
    output reg [3:0] data_out
);
    always @* begin
        if (write_enable) begin
            data_out = data_in; // Write data to EEPROM
        end else begin
            data_out = data_out; // Read data from EEPROM
        end
    end
endmodule