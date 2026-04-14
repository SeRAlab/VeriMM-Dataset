module eeprom_cell (
    input wire D,
    input wire WE,
    input wire RE,
    output reg Q
);
    always @(posedge WE or posedge RE) begin
        if (WE) begin
            Q <= D;  // Write operation
        end else if (RE) begin
            // Read operation, do nothing as Q will hold the last value.
        end
    end
endmodule