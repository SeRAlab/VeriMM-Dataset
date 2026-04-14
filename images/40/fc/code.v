module eeprom_cell (
    input wire [4:0] data_in,
    input wire write_enable,
    output reg [4:0] data_out
);
    always @(*) begin
        if (write_enable) begin
            data_out = data_in;
        end
        // else retain previous value
    end
endmodule