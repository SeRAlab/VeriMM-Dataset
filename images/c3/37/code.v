module mux_4to1_2bit (
  input [1:0] sel1_sel0,
  input [3:0] d0_d1_d2_d3,
  output reg [1:0] out
);

always @(*)
  case(sel1_sel0)
    2'b00: out = d0_d1_d2_d3[1:0];
    2'b01: out = d0_d1_d2_d3[3:2];
    2'b10: out = d0_d1_d2_d3[5:4];
    2'b11: out = d0_d1_d2_d3[7:6];
  endcase

endmodule
