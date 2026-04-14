module eeprom_cell (
    input wire D,
    input wire WE,
    input wire RE,
    output reg Q
);
    always @(posedge WE or posedge RE) begin
        if (WE) begin
            Q <= D; // Write data to the EEPROM
        end else if (RE) begin
            // Read operation, Q holds the value already stored
            // No operation needed, Q is already outputting the stored value
        end
    end
endmodule