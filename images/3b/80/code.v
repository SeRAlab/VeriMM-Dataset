module eeprom_cell (
    input wire D,         // Data input
    input wire WE,        // Write Enable
    output reg Q         // Data output
);

always @* begin
    if (WE) begin
        Q = D;          // Write data to Q when WE is high
    end
end

endmodule