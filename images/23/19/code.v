module eeprom_cell (
    input wire clock,
    input wire write_enable,
    input wire data_in,
    output reg data_out
);

always @(posedge clock) begin
    if (write_enable) begin
        data_out <= data_in;
    end
end

endmodule