module top_module(dout,
    clk,
    ram_full_fb_i_reg,
    tmp_ram_rd_en,
    out,
    \gcc0.gc0.count_d1_reg[10] ,
    Q,
    din);output [63:0]dout;
  input clk;
  input ram_full_fb_i_reg;
  input tmp_ram_rd_en;
  input [0:0]out;
  input [10:0]\gcc0.gc0.count_d1_reg[10] ;
  input [10:0]Q;
  input [63:0]din;

  reg [63:0] dout;

  always @(posedge clk) begin
    if (ram_full_fb_i_reg && !tmp_ram_rd_en) begin
      dout <= din;
    end else begin
      dout <= Q;
    end
  end
endmodule