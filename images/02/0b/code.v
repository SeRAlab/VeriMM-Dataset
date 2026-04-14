module dram_cell (
    input wire D,        // Data input
    input wire WE,       // Write enable
    input wire CLK,      // Clock
    output reg Q         // Stored data output
);
    always @(posedge CLK) begin
        if (WE) begin
            Q <= D;      // Store D on clock rising edge when WE is high
        end
    end
endmodule