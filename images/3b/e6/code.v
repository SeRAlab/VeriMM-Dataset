module dram_cell (
    input wire clk,
    input wire WE,
    input wire [3:0] D,
    output reg [3:0] Q
);
    reg [3:0] memory;

    always @(posedge clk) begin
        if (WE) begin
            memory <= D; // Write data to memory
        end
        Q <= memory; // Read data from memory
    end
endmodule