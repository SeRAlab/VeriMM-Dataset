module ram_512x32_sp
(
    input clk,
    input we,
    input [8:0] addr,
    input [31:0] wdata,
    output reg [31:0] rdata
);

reg [31:0] ram [511:0];

always @(posedge clk) begin
    if (we) begin
        ram[addr] <= wdata;
    end
    rdata <= ram[addr];
end

endmodule