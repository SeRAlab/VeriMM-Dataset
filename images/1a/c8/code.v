module dram_cell (
    input wire D,       // Data input
    input wire WL,      // Word line (control signal)
    output reg Q,       // Data output
    output reg BL       // Bit line output (for read)
);
    
    always @(posedge WL) begin
        Q <= D;          // Store data on high word line
    end

    always @(negedge WL) begin
        BL <= Q;         // Read data when word line is low
    end

endmodule