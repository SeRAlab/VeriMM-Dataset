module top_module(
  input [(3 - 1):0] sel,
  input [(8 - 1):0] d0,
  input [(8 - 1):0] d1,
  input [(8 - 1):0] d2,
  input [(8 - 1):0] d3,
  input [(8 - 1):0] d4,
  input [(8 - 1):0] d5,
  input [(8 - 1):0] d6,
  input [(8 - 1):0] d7,
  output [(8 - 1):0] y,
  input clk,
  input ce,
  input clr);wire [(3 - 1):0] sel_1_20;
  wire [(8 - 1):0] d0_1_24;
  wire [(8 - 1):0] d1_1_27;
  wire [(8 - 1):0] d2_1_30;
  wire [(8 - 1):0] d3_1_33;
  wire [(8 - 1):0] d4_1_36;
  wire [(8 - 1):0] d5_1_39;
  wire [(8 - 1):0] d6_1_42;
  wire [(8 - 1):0] d7_1_45;
  reg [(8 - 1):0] unregy_join_6_1;
  assign sel_1_20 = sel;
  assign d0_1_24 = d0;
  assign d1_1_27 = d1;
  assign d2_1_30 = d2;
  assign d3_1_33 = d3;
  assign d4_1_36 = d4;
  assign d5_1_39 = d5;
  assign d6_1_42 = d6;
  assign d7_1_45 = d7;
  always @(d0_1_24 or d1_1_27 or d2_1_30 or d3_1_33 or d4_1_36 or d5_1_39 or d6_1_42 or d7_1_45 or sel_1_20)
    begin:proc_switch_6_1
      case (sel_1_20)
        3'b000 :
          begin
            unregy_join_6_1 = d0_1_24;
          end
        3'b001 :
          begin
            unregy_join_6_1 = d1_1_27;
          end
        3'b010 :
          begin
            unregy_join_6_1 = d2_1_30;
          end
        3'b011 :
          begin
            unregy_join_6_1 = d3_1_33;
          end
        3'b100 :
          begin
            unregy_join_6_1 = d4_1_36;
          end
        3'b101 :
          begin
            unregy_join_6_1 = d5_1_39;
          end
        3'b110 :
          begin
            unregy_join_6_1 = d6_1_42;
          end
        default:
          begin
            unregy_join_6_1 = d7_1_45;
          end
      endcase
    end
  assign y = unregy_join_6_1;
endmodule