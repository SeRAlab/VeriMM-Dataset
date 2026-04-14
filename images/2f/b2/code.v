module eeprom_cell (
    input wire D,          // Data input
    input wire WE,         // Write Enable
    input wire RE,         // Read Enable
    output reg Q          // Stored Data Output
);
    always @(posedge WE or posedge RE) begin
        if (WE) begin
            Q <= D;      // Store data on write enable
        end
    end

    // Output the stored value when read enable is high
    always @(posedge RE) begin
        if (RE) begin
            Q <= Q;      // Maintain value on read enable
        end
    end
endmodule