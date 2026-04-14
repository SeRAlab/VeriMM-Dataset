module eeprom_interface (
    input [4:0] data_in,
    input [4:0] address,
    input we,
    output reg [4:0] data_out
);
    reg [4:0] memory [0:31]; // 32x5 EEPROM memory

    always @(*) begin
        if (we) begin
            memory[address] = data_in; // Write operation
            data_out = 5'b00000; // No data output during write
        end else begin
            data_out = memory[address]; // Read operation
        end
    end
endmodule