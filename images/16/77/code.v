module sram_cell (
    input wire D,      // Data input
    input wire WE,     // Write enable
    input wire CLK,    // Clock
    output reg Q       // Stored value output
);
    always @(posedge CLK) begin
        if (WE) begin
            Q <= D;    // Write data to Q if WE is high
        end
        // If WE is low, Q retains its value
    end
endmodule