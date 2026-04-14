module dram_cell (
    input wire D,
    input wire WE,
    input wire RE,
    input wire CLK,
    output reg Q
);
    always @(posedge CLK) begin
        if (WE) begin
            Q <= D; // Write data to the cell
        end
    end

    always @(posedge CLK) begin
        if (RE) begin
            // Read data from the cell, Q is already updated on write
            // No action needed for Q if RE is high
        end
    end
endmodule