module eeprom_cell (
    input wire clk,
    input wire WE,
    input wire RE,
    input wire D,
    output reg Q
);

always @(posedge clk) begin
    if (WE && !RE) begin
        Q <= D;  // Write data
    end
    else if (!WE && RE) begin
        // Read data
        // Q will automatically hold the last written value
    end
end

endmodule