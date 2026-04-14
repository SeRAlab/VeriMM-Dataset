module top_module(
  input clk,
  input rst_n,
  input [12:0] addr,
  input [2:0] ba,
  input ras_n,
  input cas_n,
  input we_n,
  input [15:0] dq,
  output [15:0] dq_i,
  output [15:0] dq_o,
  output [1:0] dqs_i,
  output [1:0] dqs_o,
  output [3:0] dm_i,
  output [3:0] dm_o
);// Internal signals
  reg [15:0] mem [0:8191];
  reg [15:0] dq_i_reg;
  reg [15:0] dq_o_reg;
  reg [1:0] dqs_i_reg;
  reg [1:0] dqs_o_reg;
  reg [3:0] dm_i_reg;
  reg [3:0] dm_o_reg;
  wire [11:0] row;
  wire [2:0] bank;
  wire [7:0] col;

  // Address decoding
  assign row = addr[11:0];
  assign bank = addr[14:12];
  assign col = addr[7:0];

  // Read operation
  always @(posedge clk) begin
    if (!rst_n) begin
      dq_o_reg <= 16'b0;
      dqs_o_reg <= 2'b0;
    end else if (!cas_n && !we_n) begin
      dq_o_reg <= mem[bank*2048+row][col];
      dqs_o_reg <= 2'b11;
    end
  end

  // Write operation
  always @(posedge clk) begin
    if (!rst_n) begin
      dq_i_reg <= 16'b0;
      dqs_i_reg <= 2'b0;
      dm_i_reg <= 4'b0;
    end else if (!cas_n && we_n) begin
      mem[bank*2048+row][col] <= dq;
      dq_i_reg <= 16'b0;
      dqs_i_reg <= 2'b0;
      dm_i_reg <= 4'b0;
    end else begin
      dq_i_reg <= dq;
      dqs_i_reg <= 2'b11;
      dm_i_reg <= 4'b1111;
    end
  end

  // Output signals
  assign dq_i = dq_i_reg;
  assign dq_o = dq_o_reg;
  assign dqs_i = dqs_i_reg;
  assign dqs_o = dqs_o_reg;
  assign dm_i = dm_i_reg;
  assign dm_o = dm_o_reg;

endmodule