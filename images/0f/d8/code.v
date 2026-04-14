module dram_cell (
    input wire D,        // Data input
    input wire RW,       // Read/Write control
    input wire CLK,      // Clock input
    output reg Q         // Data output
);

reg storage;            // Internal storage for the cell

always @(posedge CLK) begin
    if (RW) begin
        storage <= D;   // Write data to storage
    end
    Q <= storage;       // Output the stored data
end

endmodule