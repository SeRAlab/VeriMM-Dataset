module flash_memory_cell (
    input wire D,    // Data input
    input wire WE,   // Write Enable
    input wire RE,   // Read Enable
    output reg Q     // Stored output
);
    always @(posedge WE or posedge RE) begin
        if (WE) begin
            Q <= D;   // Store data on write
        end
        if (RE) begin
            // Read operation; output Q does not change unless WE is asserted
            // Q remains unchanged if both WE and RE are low
        end
    end
endmodule