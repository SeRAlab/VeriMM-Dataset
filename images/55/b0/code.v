module top_module(
  input [5:0] i_addr,
  input i_enable_x,
  input i_write_x,
  input [15:0] i_data,
  output reg [15:0] o_data
);parameter delay = 5;
  parameter depth = 64;
  parameter width = 16;

  reg [width-1:0] r_ram [0:depth-1];
  reg [5:0] r_addr;
  reg r_enable_x, r_write_x;
  reg [width-1:0] r_data;

  always @(i_addr, i_enable_x, i_write_x, i_data) begin
    r_addr = #delay i_addr;
    r_enable_x = #delay i_enable_x;
    r_write_x = #delay i_write_x;
    r_data = #delay i_data;

    if (r_enable_x) begin
      o_data <= #delay 16'bzzzzzzzzzzzzzzzz;
    end else if (r_write_x) begin
      r_ram[r_addr] <= #delay r_data;
    end else begin
      o_data <= #delay r_ram[r_addr];
    end
  end
endmodule