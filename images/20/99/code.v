module dram_cell (
    input wire [3:0] D,    // 4-bit data input
    input wire WL,         // Word line control
    output reg [3:0] Q     // 4-bit data output
);
    reg [3:0] memory;      // Internal memory storage

    always @(posedge WL) begin
        memory <= D;       // Write data to memory on WL high
    end

    always @(negedge WL) begin
        Q <= memory;       // Read data from memory on WL low
    end
endmodule