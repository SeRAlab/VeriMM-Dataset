module dram_cell (
    input wire clk,
    input wire we,          // Write enable
    input wire re,          // Read enable
    input wire [3:0] din,   // Data input
    output reg [3:0] dout   // Data output
);
    reg [3:0] memory;       // 4-bit memory storage

    always @(posedge clk) begin
        if (we) begin
            memory <= din;   // Write data to memory
        end
    end

    always @(posedge clk) begin
        if (re) begin
            dout <= memory;  // Read data from memory
        end
    end
endmodule