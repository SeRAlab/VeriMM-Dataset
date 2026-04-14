module eeprom_cell (
    input wire D,
    input wire WE,
    input wire RE,
    output reg Q
);

reg stored_data;

always @(posedge WE) begin
    stored_data <= D; // Write data to EEPROM cell
end

always @(posedge RE) begin
    Q <= stored_data; // Read data from EEPROM cell
end

endmodule