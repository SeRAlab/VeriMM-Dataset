module dram_cell (
    input wire clk,
    input wire we,        // Write enable
    input wire re,        // Read enable
    input wire [3:0] din, // 4-bit data input
    output reg [3:0] dout // 4-bit data output
);
    reg [3:0] memory; // Internal memory storage

    always @(posedge clk) begin
        if (we) begin
            memory <= din; // Write data to memory on write enable
        end
    end

    always @(posedge clk) begin
        if (re) begin
            dout <= memory; // Read data from memory on read enable
        end
    end
endmodule