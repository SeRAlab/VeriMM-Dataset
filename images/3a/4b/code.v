module SRAM_Cell (
    input wire [3:0] D,      // Data input
    input wire WE,           // Write enable
    input wire RE,           // Read enable
    input wire clk,          // Clock signal
    output reg [3:0] Q       // Data output
);
    reg [3:0] memory;         // Internal memory storage

    always @(posedge clk) begin
        if (WE) begin
            memory <= D;      // Write data to memory
        end
        if (RE) begin
            Q <= memory;      // Read data from memory
        end
    end
endmodule