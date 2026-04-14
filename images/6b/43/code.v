module ram_16x8_dp
(
    input clk,
    input we,
    input [3:0] waddr,
    input [7:0] wdata,
    input [3:0] raddr,
    output reg [7:0] rdata
);

reg [7:0] ram [15:0];

always @(posedge clk) begin
    if (we) begin
        ram[waddr] <= wdata;
    end
end

always @(*) begin
    rdata = ram[raddr];
end

endmodule