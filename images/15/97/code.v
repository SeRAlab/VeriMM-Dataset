module sram_cell (
    input wire [15:0] D,       // Data input
    input wire [3:0] addr,     // Address input
    input wire WE,             // Write enable
    input wire RE,             // Read enable
    input wire CS,             // Chip select
    output reg [15:0] Q        // Data output
);
    reg [15:0] memory [0:15];  // 16x16-bit memory array

    always @(*) begin
        if (CS) begin
            Q = 16'bz;           // High-Z state when chip is not selected
        end else if (WE && !RE) begin
            memory[addr] = D;    // Write operation
            Q = 16'bz;           // Output is high-Z during write
        end else if (RE && !WE) begin
            Q = memory[addr];     // Read operation
        end else begin
            Q = 16'bz;           // High-Z state if both WE and RE are high or neither is selected
        end
    end
endmodule