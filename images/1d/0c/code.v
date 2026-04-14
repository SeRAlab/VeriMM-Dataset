module dram_cell (
    input [15:0] D,        // 16-bit data input
    input WE,              // Write Enable
    input CLK,             // Clock
    output reg [15:0] Q    // 16-bit data output
);

reg [15:0] mem;           // Internal memory storage

always @(posedge CLK) begin
    if (WE) begin
        mem <= D;         // Write data to memory
    end
end

always @(negedge CLK) begin
    Q <= mem;            // Read data from memory
end

endmodule