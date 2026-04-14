module eeprom_cell (
    input [4:0] D,
    input write_enable,
    output reg [4:0] Q
);

always @(*) begin
    if (write_enable) begin
        Q = D; // Write operation
    end
    // If write_enable is low, Q retains its previous value
end

endmodule