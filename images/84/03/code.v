module reg_file(
    input clk,
    input we,
    input [2:0] waddr,
    input [2:0] raddr1,
    input [2:0] raddr2,
    input [15:0] wdata,

    output [15:0] rdata1,
    output [15:0] rdata2
);

reg [15:0] regs [7:0];

always @(posedge clk)
begin
    if (we)
        regs[waddr] <= wdata;
end

assign rdata1 = regs[raddr1];
assign rdata2 = regs[raddr2];

endmodule