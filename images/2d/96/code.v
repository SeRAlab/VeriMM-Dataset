module sram_cell (
    input wire D,         // Data input
    input wire WE,       // Write Enable
    input wire RE,       // Read Enable
    output reg Q         // Stored output
);

    always @(WE, D) begin
        if (WE) begin
            Q <= D;      // Store data when Write Enable is high
        end
    end

    always @(RE, Q) begin
        if (RE) begin
            // Output the stored data when Read Enable is high
            // No extra action needed since Q is already driven by the stored value
        end
    end

endmodule