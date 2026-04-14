module top_module(
  input [WIDTH-1 : 0] a,
  input [WIDTH - 1 : 0] b,
  input sub_enable,
  input carry_in,
  output [WIDTH - 1 : 0] res,
  output carry_out);parameter WIDTH = 8;
  wire [WIDTH - 1 : 0] carry;
  wire [WIDTH - 1 : 0] b_in;

  assign carry_out = carry[WIDTH-1];
  assign b_in = sub_enable ? ~(b) : b;

  genvar i;
  generate
    for (i = 0; i < WIDTH; i = i + 1) begin
      if (i == 0) begin
        assign res[i] = (a[i] ^ b_in[i]) ^ carry_in;
        assign carry[i] = ((a[i] ^ b_in[i]) & carry_in) | (a[i] & b_in[i]);
      end else begin
        assign res[i] = (a[i] ^ b_in[i]) ^ carry[i-1];
        assign carry[i] = ((a[i] ^ b_in[i]) & carry[i-1]) | (a[i] & b_in[i]);
      end
    end
  endgenerate

endmodule