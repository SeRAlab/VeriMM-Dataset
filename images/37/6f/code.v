module eeprom_cell (
    input wire D,
    input wire WE,
    input wire RE,
    output reg Q
);
    always @(*) begin
        if (WE) begin
            Q = D;  // Write data to the EEPROM cell
        end else if (RE) begin
            // Read data from the EEPROM cell
            Q = Q;  // Maintain current value when reading
        end
    end
endmodule