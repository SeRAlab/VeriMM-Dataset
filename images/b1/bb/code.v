module ram_256x16_dp
(
    input clk,
    input we,
    input [7:0] waddr,
    input [15:0] wdata,
    input [7:0] raddr,
    output reg [15:0] rdata
);

reg [15:0] ram [255:0];

always @(posedge clk) begin
    if (we) begin
        ram[waddr] <= wdata;
    end
end

always @(*) begin
    rdata = ram[raddr];
end

endmodule