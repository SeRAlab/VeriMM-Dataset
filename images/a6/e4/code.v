module top_module(dout,
    clk,
    ram_full_fb_i_reg,
    tmp_ram_rd_en,
    out,
    count_d1_reg,
    Q,
    din);output [63:0]dout;
  input clk;
  input ram_full_fb_i_reg;
  input tmp_ram_rd_en;
  input [0:0]out;
  input [10:0]count_d1_reg;
  input [10:0]Q;
  input [63:0]din;

  wire [10:0]Q;
  wire clk;
  wire [63:0]din;
  wire [63:0]dout;
  wire [10:0]count_d1_reg;
  wire [0:0]out;
  wire ram_full_fb_i_reg;
  wire tmp_ram_rd_en;

  reg [10:0] counter;
  reg [63:0] ram [1024:0];
  reg [9:0] ram_index;

  always @(posedge clk) begin
    if (ram_full_fb_i_reg) begin
      counter <= 0;
    end else begin
      counter <= counter + 1;
    end

    if (tmp_ram_rd_en && !ram_full_fb_i_reg) begin
      if (ram_index <= 1023) begin
        ram[ram_index] <= din;
        ram_index <= ram_index + 1;
      end
    end
  end

  assign dout = ram[Q];
  assign out = (ram_index == 1024) ? 1 : 0;

endmodule