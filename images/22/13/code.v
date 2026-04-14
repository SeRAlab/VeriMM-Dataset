module SRAM_Cell (
    input wire D,
    input wire WE,
    input wire RE,
    output reg Q
);
    always @ (WE, RE, D) begin
        if (WE) begin
            Q <= D; // Write data to SRAM cell
        end else if (RE) begin
            // Read data from SRAM cell
            // Q will be updated automatically when RE is high
        end
    end
endmodule