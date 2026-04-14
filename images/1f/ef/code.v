module dram_cell (
    input wire D,       // Data input
    input wire WE,      // Write Enable
    output reg Q        // Stored Output
);
    
    always @(*) begin
        if (WE) begin
            Q <= D;     // Write data to DRAM cell
        end
    end
endmodule