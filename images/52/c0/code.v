module ram_32x16_sp
(
    input clk,
    input we,
    input [4:0] addr,
    input [15:0] wdata,
    output reg [15:0] rdata
);

reg [15:0] ram [31:0];

always @(posedge clk) begin
    if (we) begin
        ram[addr] <= wdata;
    end
    rdata <= ram[addr];
end

endmodule