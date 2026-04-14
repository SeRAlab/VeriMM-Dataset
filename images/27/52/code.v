module flash_memory_cell (
    input wire D,
    input wire WE,
    input wire RE,
    output reg Q
);
    always @(posedge WE or posedge RE) begin
        if (WE) begin
            Q <= D; // Write data to the cell
        end
        if (RE) begin
            // Q reflects the stored data when RE is high
            // Q will already have the correct value from the last write
        end
    end
endmodule