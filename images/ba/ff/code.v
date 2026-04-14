module ram_64x32_dp
(
    input clk,
    input we,
    input [5:0] waddr,
    input [31:0] wdata,
    input [5:0] raddr,
    output reg [31:0] rdata
);

reg [31:0] ram [63:0];

always @(posedge clk) begin
    if (we) begin
        ram[waddr] <= wdata;
    end
end

always @(posedge clk) begin
    rdata <= ram[raddr];
end

endmodule