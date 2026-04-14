module reg_file(
    input clk,
    input we,
    input [1:0] waddr,
    input [1:0] raddr1,
    input [1:0] raddr2,
    input [7:0] wdata,

    output [7:0] rdata1,
    output [7:0] rdata2
);

reg [7:0] registers [3:0];

always @(posedge clk)
begin
    if (we)
        registers[waddr] <= wdata;
end

assign rdata1 = registers[raddr1];
assign rdata2 = registers[raddr2];

endmodule