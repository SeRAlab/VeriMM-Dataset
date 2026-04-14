module sram_cell (
    input wire [15:0] D,       // Data input
    output reg [15:0] Q,       // Data output
    input wire BL,             // Bit line
    input wire WL,             // Word line
    input wire WE              // Write enable
);
    reg [15:0] memory;         // Internal memory storage

    always @(posedge WL) begin
        if (WE) begin
            memory <= D;       // Write data to memory
        end else begin
            Q <= memory;       // Read data from memory
        end
    end
endmodule