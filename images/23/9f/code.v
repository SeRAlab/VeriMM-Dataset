module EEPROM (
    input wire D,         // Data input
    input wire CLK,       // Clock input
    input wire WE,        // Write enable
    output reg Q          // Data output
);
    
    always @(posedge CLK) begin
        if (WE) begin
            Q <= D;       // Write data to Q when WE is high
        end
        // else Q retains its previous value
    end
endmodule