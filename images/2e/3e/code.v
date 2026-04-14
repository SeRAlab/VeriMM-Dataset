module dram_cell (
    input wire D,      // Data input
    input wire WL,     // Word line (control signal)
    output reg BL,     // Bit line (output)
    output reg Q       // Data output
);
    always @(WL or D) begin
        if (WL) begin
            BL <= D;  // Write data to bit line
        end
        Q <= BL;      // Read data from bit line
    end
endmodule