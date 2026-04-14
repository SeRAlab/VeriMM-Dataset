module sram_cell (
    input wire D,      // Data input
    input wire WE,     // Write enable
    input wire RE,     // Read enable
    output reg Q       // Data output
);
    
    always @(*) begin
        if (WE) begin
            Q <= D;     // Write data to SRAM cell
        end
    end

    always @(posedge RE) begin
        if (RE) begin
            Q <= Q;     // Read data from SRAM cell (no change)
        end
    end
endmodule