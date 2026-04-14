module eeprom_cell (
    input we,
    input [4:0] data_in,
    output reg [4:0] data_out
);
    reg [4:0] storage;

    always @(*) begin
        if (we) begin
            storage = data_in; // Write data
        end
        data_out = storage; // Read data
    end
endmodule