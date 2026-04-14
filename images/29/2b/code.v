module EEPROM_Cell (
    input wire [7:0] data_in,
    input wire write_enable,
    output reg [7:0] data_out
);
    always @(*) begin
        if (write_enable) begin
            data_out = data_in; // Write data to EEPROM cell
        end
    end
endmodule