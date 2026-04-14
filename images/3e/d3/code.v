module sram_cell (
    input [3:0] d,
    input we,
    input re,
    input clk,
    output reg [3:0] q
);
    reg [3:0] memory;

    always @(posedge clk) begin
        if (we) begin
            memory <= d; // Write data to memory
        end
        if (re) begin
            q <= memory; // Read data from memory
        end
    end
endmodule