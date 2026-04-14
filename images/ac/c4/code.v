module dual_port_ram(CLK, WE, ADDR_WR, ADDR_RD, DI, DO);
input CLK, WE;
input [3:0] ADDR_WR, ADDR_RD;
input [7:0] DI;
output reg [7:0] DO;

reg [7:0] ram [0:15];

always @(posedge CLK) begin
    if (WE)
        ram[ADDR_WR] <= DI;
    DO <= ram[ADDR_RD];
end

endmodule