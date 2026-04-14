module top_module(
  input clk,
  input ce,
  input [21:0] prg_addr,
  input prg_read,
  input prg_write,
  input [7:0] prg_din,
  input [21:0] chr_addr,
  input chr_read,
  input chr_write,
  input [7:0] chr_din,
  output [21:0] memory_addr,
  output memory_read_cpu,
  output memory_read_ppu,
  output memory_write,
  output [7:0] memory_dout
);reg saved_prg_read, saved_prg_write;

  assign memory_addr = (chr_read || chr_write) ? chr_addr : prg_addr;
  assign memory_write = (chr_read || chr_write) ? chr_write : saved_prg_write;
  assign memory_read_ppu = chr_read;
  assign memory_read_cpu = !(chr_read || chr_write) && (prg_read || saved_prg_read);
  assign memory_dout = chr_write ? chr_din : prg_din;

  always @(posedge clk) begin
    if (ce) begin
      if (chr_read || chr_write) begin
        saved_prg_read <= prg_read || saved_prg_read;
        saved_prg_write <= prg_write || saved_prg_write;
      end else begin
        saved_prg_read <= 0;
        saved_prg_write <= prg_write;
      end
    end
  end

endmodule