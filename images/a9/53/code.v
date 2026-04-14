module top_module(
  output reg [255:0] DOUTB,
  input tmp_ram_rd_en,
  input rd_clk,
  input [0:0] Q,
  input I1,
  input wr_clk,
  input [8:0] O2,
  input [8:0] I2,
  input [255:0] din
);reg [255:0] mem [0:511];
  reg [8:0] wr_addr, rd_addr;
  reg [7:0] wr_offset, rd_offset;
  reg [0:0] select;

  assign DOUTB = mem[rd_addr][255:0];

  always @(posedge wr_clk) begin
    wr_offset <= O2[7:0];
    wr_addr <= O2[8:0];
    mem[wr_addr][wr_offset*32 +: 32] <= din[((wr_offset+1)*32)-1 -: 32];
  end

  always @(posedge rd_clk) begin
    rd_offset <= I2[7:0];
    rd_addr <= I2[8:0];
    select <= Q;
  end

  always @(*) begin
    if (select == 1'b0) begin
      rd_addr <= rd_addr + 1;
    end
  end

endmodule