module eeprom_cell (
    input wire [7:0] data_in,
    input wire write_enable,
    output reg [7:0] data_out
);
    always @(*) begin
        if (write_enable) begin
            data_out = data_in;
        end
        // If write_enable is low, data_out retains its last value.
    end
endmodule