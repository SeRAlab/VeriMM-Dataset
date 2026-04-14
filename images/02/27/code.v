module flash_memory (
    input wire D,       // Data input
    input wire WE,      // Write enable
    input wire RE,      // Read enable
    output reg Q        // Output data
);
    always @(WE, RE, D) begin
        if (WE) begin
            Q <= D;     // Write data to memory cell
        end else if (RE) begin
            // Output current stored data
            // No action needed as Q is already the stored value
        end
        // If both WE and RE are low, retain the current state
    end
endmodule