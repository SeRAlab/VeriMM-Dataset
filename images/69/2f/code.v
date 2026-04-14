module top_module(
    input clk,
    input rst,
    input [31:0] sram_din,
    input [31:0] mdin,
    input [31:0] wdin,
    input sram_re,
    input mwe,
    input mreq,
    input wwe,
    input wreq,
    input [SSRAM_HADR:0] sram_adr,
    input [SSRAM_HADR:0] madr,
    input [SSRAM_HADR:0] wadr,
    output reg [31:0] sram_dout,
    output reg sram_we,
    output reg mdout,
    output reg [31:0] wdout,
    output reg wack
);parameter SSRAM_HADR = 14;

reg [SSRAM_HADR:0] sram_adr_reg;
reg [31:0] sram_dout_reg;
reg sram_we_reg;
reg mack_reg;
reg mcyc_reg;
reg wack_r_reg;

assign wsel = (wreq | wack) & !mreq;

always @(wsel or wdin or mdin)
    if (wsel) sram_dout_reg = wdin;
    else sram_dout_reg = mdin;

always @(wsel or wadr or madr)
    if (wsel) sram_adr_reg = wadr;
    else sram_adr_reg = madr;

always @(wsel or wwe or wreq or mwe or mcyc_reg)
    if (wsel) sram_we_reg = wreq & wwe;
    else sram_we_reg = mwe & mcyc_reg;

assign sram_dout = sram_dout_reg;
assign sram_adr = sram_adr_reg;
assign sram_we = sram_we_reg;
assign sram_re = 1'b1;

assign mdout = sram_din;
assign mack_reg = mreq;
assign mcyc_reg = mack_reg;

assign wdout = sram_din;
assign wack = wack_r_reg & !mreq;

always @(posedge clk or negedge rst)
    if (rst) wack_r_reg <= 1'b0;
    else wack_r_reg <= wreq & !mreq & !wack;

endmodule