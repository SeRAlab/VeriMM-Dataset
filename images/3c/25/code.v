module eeprom_cell (
    input wire we,
    input wire re,
    input wire rst,
    input wire d,
    output reg q
);
    always @(posedge we or posedge rst) begin
        if (rst) begin
            q <= 1'b0; // Clear the cell on reset
        end else if (we) begin
            q <= d; // Write data to cell
        end
    end

    always @(posedge re) begin
        if (re) begin
            // Read operation happens here, but q is already assigned in the write operation
            // So q will contain the last written value when re is high
        end
    end
endmodule