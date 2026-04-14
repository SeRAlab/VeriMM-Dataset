module eeprom_cell (
    input wire D,
    input wire WE,
    input wire RE,
    output reg Q
);
    
    always @(*) begin
        if (WE) begin
            Q = D; // Store data when write enable is high
        end else if (RE) begin
            // Output the stored data when read enable is high
            Q = Q; // Maintain the stored value
        end else begin
            Q = Q; // Maintain the stored value
        end
    end
endmodule