module dram_cell (
    input wire D,        // Data input
    input wire WE,       // Write enable
    output reg Q         // Data output
);
    always @(WE or D) begin
        if (WE) begin
            Q <= D;     // Write data to Q when WE is high
        end
        // If WE is low, we retain the previous value of Q
    end
endmodule