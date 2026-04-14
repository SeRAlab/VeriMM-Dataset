module eeprom_cell (
    input wire write_enable,
    input wire data_in,
    input wire read_enable,
    output reg data_out
);
    always @(posedge write_enable) begin
        data_out <= data_in; // Write data when write_enable is high
    end

    always @(posedge read_enable) begin
        // data_out is driven by the stored value
    end
endmodule