module top_module(
    input clk,
    input en,
    input we,
    input [ADDR_WIDTH-1:0] addr,
    input [DATA_WIDTH-1:0] din,
    output reg [DATA_WIDTH-1:0] dout
);parameter ADDR_WIDTH = 8; // Adjusted for example
    parameter DATA_WIDTH = 8; // Adjusted for example
    parameter MEMSIZE = 256; // Adjusted for example

    reg [DATA_WIDTH-1:0] memory [0:MEMSIZE-1]; // Simple memory array
    reg [DATA_WIDTH-1:0] DOA;
    reg [DATA_WIDTH-1:0] DOA_R2;

    // Simplified BRAM2 instantiation as a behavioral memory
    always @(posedge clk) begin
        if (en) begin
            if (we) begin
                // Write operation
                memory[addr] <= din;
            end else begin
                // Read operation
                dout <= memory[addr];
            end
        end
    end

    always @(posedge clk) begin
        DOA_R2 <= DOA;
    end

endmodule