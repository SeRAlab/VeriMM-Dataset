module top_module(Q,
   clk,
   din,
   dout,
   count_d1_reg,
   out,
   ram_full_fb_i_reg,
   tmp_ram_rd_en);input [11:0] Q;
  input clk;
  input [8:0] din;
  output [8:0] dout;
  input [11:0] count_d1_reg;
  input [0:0] out;
  input ram_full_fb_i_reg;
  input tmp_ram_rd_en;

  reg [11:0] count_reg;
  reg [8:0] mem [0:15];
  reg [3:0] write_ptr;
  reg [3:0] read_ptr;
  reg [3:0] count;
  wire full = (count == 16);
  wire empty = (count == 0);
  wire rd_en = (tmp_ram_rd_en && !empty);
  wire wr_en = (!full);

  assign dout = mem[read_ptr];
  assign Q = count_reg;

  always @(posedge clk) begin
    if (wr_en) begin
      mem[write_ptr] <= din;
      write_ptr <= write_ptr + 1;
      count <= count + 1;
    end
    if (rd_en) begin
      read_ptr <= read_ptr + 1;
      count <= count - 1;
    end
    if (ram_full_fb_i_reg) begin
      count_reg <= count_d1_reg;
    end
    else begin
      count_reg <= count;
    end
  end

endmodule