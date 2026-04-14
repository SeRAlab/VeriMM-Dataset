module eeprom_cell (
    input wire data_in,
    input wire write_enable,
    input wire read_enable,
    output reg data_out
);
    
    reg stored_data;

    always @(posedge write_enable) begin
        stored_data <= data_in; // Write data to EEPROM cell
    end

    always @(posedge read_enable) begin
        data_out <= stored_data; // Read data from EEPROM cell
    end

endmodule