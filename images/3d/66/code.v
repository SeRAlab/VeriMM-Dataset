module eeprom_cell (
    input wire data_in,
    input wire write_enable,
    output reg data_out
);
    always @(posedge write_enable) begin
        if (write_enable) begin
            data_out <= data_in;
        end
    end
endmodule