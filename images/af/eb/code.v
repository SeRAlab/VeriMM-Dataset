module top_module(
  input [7:0] in,
  output reg out1,
  output reg out2
);wire [3:0] nor1_out;
  wire [3:0] nor2_out;
  wire [1:0] nor3_out;

  // Implementing NOR gates
  assign nor1_out[0] = ~(in[0] | in[1]);
  assign nor1_out[1] = ~(in[2] | in[3]);
  assign nor1_out[2] = ~(in[4] | in[5]);
  assign nor1_out[3] = ~(in[6] | in[7]);

  assign nor2_out[0] = ~(nor1_out[0] | nor1_out[1]);
  assign nor2_out[1] = ~(nor1_out[2] | nor1_out[3]);

  assign nor3_out[0] = ~(nor2_out[0] | nor2_out[1]);

  // Assigning output signals
  always @* begin
    out1 = nor3_out[0];
    out2 = ~(nor3_out[0] | nor3_out[1]);
  end

endmodule