module top_module(
    input [3:0] addr0,
    input ce0,
    input [63:0] d0,
    input we0,
    output reg [63:0] q0,
    input clk
);parameter DWIDTH = 64;
parameter AWIDTH = 4;
parameter MEM_SIZE = 16;

reg [DWIDTH-1:0] ram [MEM_SIZE-1:0];

always @(posedge clk) begin
    if (ce0) begin
        if (we0) begin
            ram[addr0] <= d0;
        end
        q0 <= ram[addr0];
    end
end

endmodule