module eeprom_cell (
    input wire D,      // Data input
    input wire WE,     // Write enable
    output reg Q       // Data output
);
    always @(*) begin
        if (WE) begin
            Q = D;       // Store the value of D when WE is high
        end
    end
endmodule