module ram_128x64_sp
(
    input clk,
    input we,
    input [6:0] addr,
    input [63:0] wdata,
    output reg [63:0] rdata
);

reg [63:0] ram [127:0];

always @(posedge clk) begin
    if (we) begin
        ram[addr] <= wdata;
    end
    rdata <= ram[addr];
end

endmodule