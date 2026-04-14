module eeprom_cell (
    input wire data_in,
    input wire write_enable,
    input wire read_enable,
    output reg data_out
);
    always @(posedge write_enable) begin
        data_out <= data_in; // Write data into EEPROM cell
    end

    always @(posedge read_enable) begin
        // Read data from EEPROM cell (data_out already updated on write)
    end
endmodule