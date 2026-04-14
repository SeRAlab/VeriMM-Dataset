module dram_cell (
    input wire D,       // Data input
    input wire WE,      // Write enable
    input wire RE,      // Read enable
    output reg Q        // Data output
);
    always @(posedge WE or posedge RE) begin
        if (WE) begin
            Q <= D;    // Write data to cell
        end
        // Reading is allowed when RE is high; don't change Q during read
    end
endmodule