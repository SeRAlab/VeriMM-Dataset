module dram_cell (
    input wire D,    // Data input
    input wire WE,   // Write enable
    output reg Q     // Stored value output
);

always @(WE or D) begin
    if (WE) begin
        Q <= D;  // Store the value of D when WE is high
    end
end

endmodule