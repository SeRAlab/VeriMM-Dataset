module top_module(
  input [(32 - 1):0] x,
  output [(32 - 1):0] z,
  input clk,
  input ce,
  input clr);wire signed [(32 - 1):0] x_1_22;
  localparam [(11 - 1):0] const_value = 11'b10010000000;
  localparam [(11 - 1):0] const_value_x_000000 = 11'b11111111111;
  localparam [(11 - 1):0] const_value_x_000001 = 11'b10010000000;
  localparam signed [(32 - 1):0] const_value_x_000002 = 32'sb00000100100000000000000000000000;
  wire rel_3_6;
  localparam [(11 - 1):0] const_value_x_000003 = 11'b11111111111;
  localparam signed [(32 - 1):0] const_value_x_000004 = 32'sb00000111111111110000000000000000;
  wire rel_5_10;
  reg signed [(32 - 1):0] z_join_3_3;
  localparam signed [(32 - 1):0] const_value_x_000005 = 32'sb00000100100000000000000000000000;
  localparam signed [(32 - 1):0] const_value_x_000006 = 32'sb00000111111111110000000000000000;
  assign x_1_22 = x;
  assign rel_3_6 = x_1_22 < const_value_x_000002;
  assign rel_5_10 = x_1_22 > const_value_x_000004;
  always @(rel_3_6 or rel_5_10 or x_1_22)
    begin:proc_if_3_3
      if (rel_3_6)
        begin
          z_join_3_3 = const_value_x_000005;
        end
      else if (rel_5_10)
        begin
          z_join_3_3 = const_value_x_000006;
        end
      else 
        begin
          z_join_3_3 = x_1_22;
        end
    end
  assign z = z_join_3_3;
endmodule