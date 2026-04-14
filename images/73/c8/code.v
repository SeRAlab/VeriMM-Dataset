module top_module(
  input [(32 - 1):0] b,
  input [(1 - 1):0] rst,
  input [(1 - 1):0] en,
  output [(32 - 1):0] q,
  input clk,
  input ce,
  input clr);wire signed [(32 - 1):0] b_17_24;
  wire rst_17_27;
  wire en_17_32;
  reg signed [(32 - 1):0] accum_reg_41_23 = 32'b00000000000000000000000000000000;
  wire accum_reg_41_23_rst;
  wire accum_reg_41_23_en;
  localparam [(1 - 1):0] const_value = 1'b0;
  localparam [(1 - 1):0] const_value_x_000000 = 1'b1;
  localparam [(1 - 1):0] const_value_x_000001 = 1'b0;
  localparam [(1 - 1):0] const_value_x_000002 = 1'b1;
  reg signed [(33 - 1):0] accum_reg_join_47_1;
  reg accum_reg_join_47_1_en;
  reg accum_reg_join_47_1_rst;
  assign b_17_24 = b;
  assign rst_17_27 = rst;
  assign en_17_32 = en;
  always @(posedge clk)
    begin:proc_accum_reg_41_23
      if (((ce == 1'b1) && (accum_reg_41_23_rst == 1'b1)))
        begin
          accum_reg_41_23 <= 32'b00000000000000000000000000000000;
        end
      else if (((ce == 1'b1) && (accum_reg_41_23_en == 1'b1)))
        begin
          accum_reg_41_23 <= accum_reg_41_23 + b_17_24;
        end
    end
  always @(accum_reg_41_23 or b_17_24 or en_17_32 or rst_17_27)
    begin:proc_if_47_1
      if (rst_17_27)
        begin
          accum_reg_join_47_1_rst = 1'b1;
        end
      else if (en_17_32)
        begin
          accum_reg_join_47_1_rst = 1'b0;
        end
      else 
        begin
          accum_reg_join_47_1_rst = 1'b0;
        end
      if (en_17_32)
        begin
          accum_reg_join_47_1_en = 1'b1;
        end
      else 
        begin
          accum_reg_join_47_1_en = 1'b0;
        end
    end
  assign accum_reg_41_23_rst = accum_reg_join_47_1_rst;
  assign accum_reg_41_23_en = accum_reg_join_47_1_en;
  assign q = accum_reg_41_23;
endmodule