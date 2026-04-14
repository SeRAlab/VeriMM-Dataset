module top_module(
    input clk,
    input [31:0] data,
    input we,
    input [9:0] addr,
    output reg [31:0] out
);parameter ADDR_WIDTH = 10;
parameter DATA_WIDTH = 32;

reg [DATA_WIDTH-1:0] RAM[2**ADDR_WIDTH-1:0];

always @(posedge clk) begin
    if (we) begin
        RAM[addr] <= data;
    end
    out <= RAM[addr];
end

endmodule