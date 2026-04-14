module eeprom_cell (
    input [4:0] data_in,
    input write,
    output reg [4:0] data_out
);
    always @(*) begin
        if (write) begin
            data_out = data_in; // Write data to EEPROM
        end
        // else retain previous value
    end
endmodule