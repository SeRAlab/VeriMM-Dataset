module eeprom_cell (
    input clk,
    input we,
    input d,
    output reg q
);

always @(posedge clk) begin
    if (we) begin
        q <= d; // Store data on write enable
    end
    // If we is low, q retains its previous value
end

endmodule