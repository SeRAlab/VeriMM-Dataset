module eeprom_cell(
    input wire D,         // Data input
    input wire WE,       // Write enable
    input wire RE,       // Erase enable
    input wire clk,      // Clock signal
    output reg Q         // Data output
);

always @(posedge clk) begin
    if (RE) begin
        Q <= 1'b0;       // Erase operation sets Q to 0
    end else if (WE) begin
        Q <= D;          // Write operation stores D into Q
    end
    // Read operation occurs when WE and RE are low
end

endmodule