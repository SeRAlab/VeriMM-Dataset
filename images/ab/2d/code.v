module top_module(
    input clk,
    input rst,
    input [7:0] di,
    input [7:0] addr,
    output reg [7:0] doq,
    output reg tag_v
);parameter ADDR_WIDTH = 8;
parameter DATA_WIDTH = 8;
parameter MEM_DEPTH = 256;

reg [DATA_WIDTH-1:0] mem [MEM_DEPTH-1:0];
reg [ADDR_WIDTH-1:0] addr_reg;

always @(posedge clk) begin
    if (rst) begin
        addr_reg <= 0;
        doq <= 0;
        tag_v <= 0;
    end else begin
        addr_reg <= addr;
        if (tag_v) begin
            doq <= mem[addr_reg];
        end
    end
end

always @(posedge clk) begin
    if (rst) begin
        tag_v <= 0;
    end else if (addr_reg == addr) begin
        if (tag_v) begin
            mem[addr_reg] <= di;
        end else begin
            tag_v <= 1;
            mem[addr_reg] <= di;
        end
    end
end

endmodule