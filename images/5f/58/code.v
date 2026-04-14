module top_module(
  input [4:0] i_0,
  input [4:0] i_1,
  input [4:0] i_2,
  input [1:0] i_3,
  input [1:0] i_4,
  input i_5,
  input reset,
  input clk,  // Added clk input
  output [6:0] o_0,
  output [6:0] o_1,
  output [6:0] o_2,
  output o_3,
  output o_4
);reg [4:0] i_0_reg;
  reg [4:0] i_1_reg;
  reg [4:0] i_2_reg;
  reg [1:0] i_3_reg;
  reg [1:0] i_4_reg;
  reg i_5_reg;
  reg reset_reg;

  wire [6:0] o_0_wire;
  wire [6:0] o_1_wire;
  wire [6:0] o_2_wire;
  wire wire_0;
  wire wire_1;

  assign o_0 = o_0_wire;
  assign o_1 = o_1_wire;
  assign o_2 = o_2_wire;
  assign o_3 = wire_0;
  assign o_4 = wire_1;

  always @(posedge clk or posedge reset) begin
    if (reset) begin
      i_0_reg <= 5'b0;
      i_1_reg <= 5'b0;
      i_2_reg <= 5'b0;
      i_3_reg <= 2'b0;
      i_4_reg <= 2'b0;
      i_5_reg <= 1'b0;
      reset_reg <= 1'b1;
    end else begin
      i_0_reg <= i_0;
      i_1_reg <= i_1;
      i_2_reg <= i_2;
      i_3_reg <= i_3;
      i_4_reg <= i_4;
      i_5_reg <= i_5;
      reset_reg <= 1'b0;
    end
  end

  assign o_0_wire = {i_0_reg, i_1_reg, i_2_reg};
  assign o_1_wire = {i_3_reg, i_4_reg, i_5_reg};
  assign o_2_wire = {o_0_wire, o_1_wire};

  assign wire_0 = (i_3_reg == 2'b11) && (i_4_reg == 2'b11);
  assign wire_1 = wire_0 && i_5_reg;

endmodule