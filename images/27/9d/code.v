module eeprom_cell (
    input wire write_enable,
    input wire data_in,
    output reg data_out
);
    always @(*) begin
        if (write_enable) begin
            data_out = data_in; // Store the value when writing
        end
    end
endmodule