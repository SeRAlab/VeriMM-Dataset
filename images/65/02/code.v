module top_module(clock, reset, x, k0, k1, k2, k3, out);parameter BITS = 8;
  parameter STAGES = 3;

  input clock;
  input reset;
  input [BITS-1:0] x;
  input [BITS-1:0] k0;
  input [BITS-1:0] k1;
  input [BITS-1:0] k2;
  input [BITS-1:0] k3;
  output reg [BITS-1:0] out;

  reg [BITS-1:0] x_reg [0:STAGES];
  wire [BITS-1:0] mult_out [0:STAGES];
  wire [BITS-1:0] add_out [0:STAGES-1];

  assign mult_out[0] = k0 * x_reg[0];
  assign mult_out[1] = k1 * x_reg[1];
  assign mult_out[2] = k2 * x_reg[2];
  assign mult_out[3] = k3 * x_reg[3];

  assign add_out[0] = mult_out[0] + mult_out[1];
  assign add_out[1] = add_out[0] + mult_out[2];
  assign add_out[2] = add_out[1] + mult_out[3];

  always @(posedge clock) begin
    if (reset) begin
      out <= 0;
      x_reg[0] <= 0;
      x_reg[1] <= 0;
      x_reg[2] <= 0;
      x_reg[3] <= 0;
    end else begin
      out <= add_out[2];
      x_reg[0] <= x;
      x_reg[1] <= x_reg[0];
      x_reg[2] <= x_reg[1];
      x_reg[3] <= x_reg[2];
    end
  end
endmodule