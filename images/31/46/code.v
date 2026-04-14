module dram_cell (
    input wire [7:0] D,     // Data input
    input wire WE,          // Write enable
    input wire RE,          // Read enable
    input wire CLK,         // Clock
    output reg [7:0] Q      // Data output
);
    reg [7:0] memory;        // Internal memory storage

    always @(posedge CLK) begin
        if (WE && !RE) begin
            memory <= D;      // Write data to memory
        end
        if (RE && !WE) begin
            Q <= memory;      // Read data from memory
        end
    end
endmodule