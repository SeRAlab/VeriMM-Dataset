module sram_cell (
    input wire D,
    input wire WE,
    input wire RE,
    output reg Q
);
    always @(WE, D) begin
        if (WE) begin
            Q <= D; // Write data to the SRAM cell
        end
    end

    always @(RE) begin
        if (RE) begin
            // Output the stored data when RE is high
            // Q is already updated by the write operation if WE was high
        end
    end
endmodule