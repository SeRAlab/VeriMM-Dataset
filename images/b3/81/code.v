module top_module( IN0, IN1, CTRL, OUT1 );input [3:0] IN0;
  input [3:0] IN1;
  output [3:0] OUT1;
  input CTRL;

  wire mux1_out;
  wire mux2_out;
  wire mux3_out;
  wire mux4_out;

  assign mux1_out = (CTRL == 1'b1) ? IN1[3] : IN0[3];
  assign mux2_out = (CTRL == 1'b1) ? IN1[2] : IN0[2];
  assign mux3_out = (CTRL == 1'b1) ? IN1[1] : IN0[1];
  assign mux4_out = (CTRL == 1'b1) ? IN1[0] : IN0[0];

  assign OUT1 = {mux1_out, mux2_out, mux3_out, mux4_out};
endmodule